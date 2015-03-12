module Comparator
  def self.compare_model_attributes(original_attributes, new_attributes)
    diff = {}

    original_attributes.keys.each do |key|
      original_val = original_attributes["#{key}"] || original_attributes["#{key}".to_sym]
      new_val = new_attributes["#{key}"] || new_attributes["#{key}".to_sym]

      if self.attr_is_an_object(original_val)
        hash_diff = self.compare_hashes
        diff["#{key}".to_sym] = hash_diff if hash_diff.present?
      elsif self.attr_is_a_list(original_val)
        list_diff = self.compare_lists(original_val, new_val)
        diff["#{key}".to_sym] = list_diff if list_diff.present?
      else
        if original_val != new_val
          diff["#{key}".to_sym] = {
            original_val: original_val,
            new_val: new_val
          }
        end
      end
    end

    diff
  end

  def self.compare_hashes(first_hash, second_hash)
    diff = {}

    first_hash.keys.each do |key|
      original_val = first_hash["#{key}"] || first_hash["#{key}".to_sym]
      new_val = second_hash["#{key}"] || second_hash["#{key}".to_sym]

      if original_val != new_val
        diff["#{key}".to_sym] = {
          original_val: original_val,
          new_val: new_val
        }
      end
    end

    diff.empty? ? nil : diff
  end

  def self.compare_lists(first_list, second_list)
    diff = nil

    if first_list != second_list
      diff = {
        original_vals: first_list,
        new_vals: second_list
      }
    end

    diff
  end
  
  def self.attr_is_an_object(val)
    val.is_a?(Hash)
  end

  def self.attr_is_a_list(val)
    val.is_a?(Array)
  end
end
