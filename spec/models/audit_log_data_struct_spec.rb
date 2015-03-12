require 'rails_helper'

describe AuditLogDataStruct do
  describe '.initialize' do
    it 'should raise an exception when no arguments are passed in' do
      expect{
        AuditLogDataStruct.new
      }.to raise_exception(AuditLogException::MissingArguments)
    end

    it 'should raise an exception when not all required arguments are passed in' do
      expect{
        AuditLogDataStruct.new({
          audited_user_id: 1,
          blacklist_file: 'admin_user_audit_log_blacklist.yml'
        })
      }.to raise_exception(AuditLogException::MissingArguments)
    end

    it 'should not raise an exception when all required arguments are passed in' do
      expect{
        AuditLogDataStruct.new({
          audited_user_id: 1,
          save_to_model: 'AdminUserAudit',
          http_request_object: {
            method: 'POST',
            ip: '127.0.0.1'
          },
          http_request_params: {
            "utf8"=>"check",
            "authenticity_token"=>"kdsjfakldsjfk;lsdjfsomeauthentictytoken",
            "admin_user"=> {
              "email"=>"greg@me.com",
              "current_password"=>"[FILTERED]",
              "password"=>"[FILTERED]",
              "password_confirmation"=>"[FILTERED]"
            },
            "commit"=>"Update Admin user",
            "id"=>"2"
          },
          blacklist_file: 'admin_user_audit_log_blacklist.yml',
          original_attributes_before_update: {
            email: 'greggy@me.com'
          },
          new_attributes_after_update: {
            email: 'greg@me.com'
          }
        })
      }.not_to raise_exception
    end

    it 'should not raise an exception when the optional paramaters are omitted' do
      expect{
        AuditLogDataStruct.new({
          audited_user_id: 1,
          save_to_model: 'AdminUserAudit',
          http_request_object: {
            method: 'POST',
            ip: '127.0.0.1'
          },
          http_request_params: {
            "utf8"=>"check",
            "authenticity_token"=>"kdsjfakldsjfk;lsdjfsomeauthentictytoken",
            "admin_user"=> {
              "email"=>"greg@me.com",
              "current_password"=>"[FILTERED]",
              "password"=>"[FILTERED]",
              "password_confirmation"=>"[FILTERED]"
            },
            "commit"=>"Update Admin user",
            "id"=>"2"
          },
        })
      }.not_to raise_exception
    end
  end

  describe '.check_if_blacklist_file_exists' do
    it 'should raise an exception when the blacklist_file argument is an invalid file' do
      expect{
        AuditLogDataStruct.new({
          audited_user_id: 1,
          save_to_model: 'AdminUserAudit',
          http_request_object: {
            method: 'POST',
            ip: '127.0.0.1'
          },
          http_request_params: {
            "utf8"=>"check",
            "authenticity_token"=>"kdsjfakldsjfk;lsdjfsomeauthentictytoken",
            "admin_user"=> {
              "email"=>"greg@me.com",
              "current_password"=>"[FILTERED]",
              "password"=>"[FILTERED]",
              "password_confirmation"=>"[FILTERED]"
            },
            "commit"=>"Update Admin user",
            "id"=>"2"
          },
          blacklist_file: 'file_does_not_exist.yml'
        })
      }.to raise_exception(AuditLogException::FileNotFound)
    end

    it 'should not raise an exception when the blacklist_file argument is a valid file' do
      expect{
        AuditLogDataStruct.new({
          audited_user_id: 1,
          save_to_model: 'AdminUserAudit',
          http_request_object: {
            method: 'POST',
            ip: '127.0.0.1'
          },
          http_request_params: {
            "utf8"=>"check",
            "authenticity_token"=>"kdsjfakldsjfk;lsdjfsomeauthentictytoken",
            "admin_user"=> {
              "email"=>"greg@me.com",
              "current_password"=>"[FILTERED]",
              "password"=>"[FILTERED]",
              "password_confirmation"=>"[FILTERED]"
            },
            "commit"=>"Update Admin user",
            "id"=>"2"
          },
          blacklist_file: 'admin_user_audit_log_blacklist.yml'
        })
      }.not_to raise_exception
    end
  end

  describe '.check_if_model_exists' do
    it 'should not raise an exception when a valid audit log model is passed in' do
      expect{
        AuditLogDataStruct.new({
          audited_user_id: 1,
          save_to_model: 'AdminUserAudit',
          http_request_object: {
            method: 'POST',
            ip: '127.0.0.1'
          },
          http_request_params: {
            "utf8"=>"check",
            "authenticity_token"=>"kdsjfakldsjfk;lsdjfsomeauthentictytoken",
            "admin_user"=> {
              "email"=>"greg@me.com",
              "current_password"=>"[FILTERED]",
              "password"=>"[FILTERED]",
              "password_confirmation"=>"[FILTERED]"
            },
            "commit"=>"Update Admin user",
            "id"=>"2"
          }
        })
      }.to_not raise_exception
    end

    it 'should raise an exception when an invalid audit log model is passed in' do
      expect{
        AuditLogDataStruct.new({
          audited_user_id: 1,
          save_to_model: 'FakeModel',
          http_request_object: {
            method: 'POST',
            ip: '127.0.0.1'
          },
          http_request_params: {
            "utf8"=>"check",
            "authenticity_token"=>"kdsjfakldsjfk;lsdjfsomeauthentictytoken",
            "admin_user"=> {
              "email"=>"greg@me.com",
              "current_password"=>"[FILTERED]",
              "password"=>"[FILTERED]",
              "password_confirmation"=>"[FILTERED]"
            },
            "commit"=>"Update Admin user",
            "id"=>"2"
          }
        })
      }.to raise_exception(AuditLogException::ModelDoesNotExist)
    end
  end
end
