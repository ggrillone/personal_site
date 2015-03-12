module AuditLogException
  class MissingArguments < StandardError; end
  class FileNotFound < StandardError; end
  class ModelDoesNotExist < StandardError; end
  class InvalidArgumentType < StandardError; end
end