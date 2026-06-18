# frozen_string_literal: true

require "oj"

Alba.encoder = ->(hash) { Oj.dump(hash, mode: :compat) }
Alba.inflector = :active_support
