require 'rails_helper'

describe AuditLogException do
  describe 'MissingArguments' do
    it 'should raise an exception' do
      expect{raise AuditLogException::MissingArguments}.to raise_error(AuditLogException::MissingArguments)
    end
  end

  describe 'FileNotFound' do
    it 'should raise an exception' do
      expect{raise AuditLogException::FileNotFound}.to raise_error(AuditLogException::FileNotFound)
    end
  end

  describe 'ModelDoesNotExist' do
    it 'should raise an exception' do
      expect{raise AuditLogException::ModelDoesNotExist}.to raise_error(AuditLogException::ModelDoesNotExist)
    end
  end

  describe "InvalidArgumentType" do
    it 'should raise an exception' do
      expect{raise AuditLogException::InvalidArgumentType}.to raise_error(AuditLogException::InvalidArgumentType)
    end
  end
end
