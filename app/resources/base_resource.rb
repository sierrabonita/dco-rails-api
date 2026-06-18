# frozen_string_literal: true

class BaseResource
  include Alba::Resource

  # フロントエンド側に合わせてデフォルトで lowerCamelCase に変換する
  transform_keys :lower_camel
end
