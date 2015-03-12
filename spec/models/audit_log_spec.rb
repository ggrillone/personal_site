require 'rails_helper'

describe AuditLog do
  describe ".validate_audit_log_data" do
    it 'should not raise an exception when a valid argument type is passed' do
      audit_log_data_struct = AuditLogDataStruct.new({
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

      expect{AuditLog.create(audit_log_data_struct)}.not_to raise_exception
    end

    it 'should raise an exception when an invalid argument type is passed' do
      audit_log_data_struct = {
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
      }

      expect{AuditLog.create(audit_log_data_struct)}.to raise_exception(AuditLogException::InvalidArgumentType)
    end
  end
end