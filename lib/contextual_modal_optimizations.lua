-- Optimized version of contextual modal key binding checking
-- Replaces linear search with hash map lookup for better performance

local function createBindingKey(mods, key)
  -- Create a unique string key for mods + key combination
  local modString = table.concat(mods or {}, "|")
  return modString .. ":" .. key
end

local ContextualModalOptimizations = {}

-- Optimized version of hasBinding that uses O(1) hash lookup instead of O(n) linear search
function ContextualModalOptimizations:hasBindingOptimized(mods, key)
  if not self.bindingHash then
    self.bindingHash = {}
  end
  
  local bindingKey = createBindingKey(mods, key)
  return self.bindingHash[bindingKey] == true
end

-- Optimized version of registerBinding that maintains hash map
function ContextualModalOptimizations:registerBindingOptimized(mods, key)
  if not self.bindings[key] then 
    self.bindings[key] = {} 
  end
  if not self.bindingHash then
    self.bindingHash = {}
  end

  table.insert(self.bindings[key], mods)
  
  -- Also store in hash map for fast lookup
  local bindingKey = createBindingKey(mods, key)
  self.bindingHash[bindingKey] = true

  return self
end

-- Batch key registration for better performance when setting up many bindings
function ContextualModalOptimizations:registerBindingsBatch(bindings)
  if not self.bindingHash then
    self.bindingHash = {}
  end
  
  for _, binding in ipairs(bindings) do
    local mods, key = binding.mods, binding.key
    
    if not self.bindings[key] then 
      self.bindings[key] = {} 
    end
    
    table.insert(self.bindings[key], mods)
    
    local bindingKey = createBindingKey(mods, key)
    self.bindingHash[bindingKey] = true
  end
  
  return self
end

-- Performance monitoring helper
function ContextualModalOptimizations:measureBindingPerformance(mods, key, iterations)
  iterations = iterations or 1000
  
  -- Measure original method
  local startTime = os.clock()
  for i = 1, iterations do
    self:hasBinding(mods, key)
  end
  local originalTime = os.clock() - startTime
  
  -- Measure optimized method
  startTime = os.clock()
  for i = 1, iterations do
    self:hasBindingOptimized(mods, key)
  end
  local optimizedTime = os.clock() - startTime
  
  return {
    original = originalTime,
    optimized = optimizedTime,
    improvement = originalTime / optimizedTime
  }
end

return ContextualModalOptimizations