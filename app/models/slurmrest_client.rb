#!/usr/bin/env ruby
# {"administrator_level"=>"None", "associations"=>[{"account"=>"chimica_1", "cluster"=>"cesia", "partition"=>nil, "user"=>"davide.duzzi2"}], "coordinators"=>[], "default"=>{"account"=>"chimica_1", "wckey"=>""}, "name"=>"davide.duzzi2"}

# sul server slurm scontrol token lifespan=86400
# sacctmgr dump cesia
#
require "faraday"
require "json"

class SlurmrestClient
  BASE_URI = "http://lcsp-slurm-01.hpc.unibo.it:6820"

  B = "/slurmdb/v0.0.38"

  def conn
    @c ||= Faraday.new(url: BASE_URI, headers: {"X-SLURM-USER-NAME" => "root", "X-SLURM-USER-TOKEN" => ENV["SLURM_JWT"]}) do |builder|
      builder.request :json
      builder.response :json
      builder.response :raise_error
    end
  end

  def oas
    conn.get("/openapi/v3")
  end

  def get_accounts
    r = conn.get("#{B}/accounts")
    r.body["accounts"] if r.status == 200
  end

  def get_users
    r = conn.get("#{B}/users")
    r.body["users"] if r.status == 200
  end

  def get_associations
    r = conn.get("#{B}/associations")
    r.body["associations"] if r.status == 200
  end

  def get_user_associations(user)
    r = conn.get("#{B}/associations", {user: user})
    r.body["associations"] if r.status == 200
  end

  def get_account_associations(account)
    r = conn.get("#{B}/associations", {account: [account]})
    r.body["associations"] if r.status == 200
  end

  # First create the account and then the association. Strange but necessary (see what happens with sacctmgr create account name=test01)
  def add_account(name:, description:, organization:, fairshare: 80)
    q = {accounts: [{name: name, description: description, organization: organization, fairshare: fairshare, cluster: "cesia"}]}
    r = conn.post("#{B}/accounts/", q)
    if r.status == 200
      q = {associations: [{account: name, cluster: "cesia"}]}
      r = conn.post("#{B}/associations/", q)
    end
    r.status == 200
  end

  def add_user(name)
    q = {users: [{name: name}]}
    r = conn.post("#{B}/users/", q)
    r.status == 200
  end

  def add_user_to_account(name, account)
    q = {associations: [{account: account, user: name, cluster: "cesia"}]}
    r = conn.post("#{B}/associations/", q)
    r.status == 200
  end
end
