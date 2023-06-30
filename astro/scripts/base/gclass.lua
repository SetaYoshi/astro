function Engine.newItemClass(args)
  local class = {}

  class.name = args.name
  class.MAX_ID = args.MAX_ID
  class.MAX_AMOUNT = args.MAX_AMOUNT
  class.methods = args.methods or {}

  class.array = {}
  class.permIDMax = 0

  class.config = {}
  class.NAME_MAP = {}


  class.register = function(conf)
    class.NAME_MAP[conf.name] = conf.id
    class.config[conf.id] = Engine.config(class, conf)
    return conf
  end

  class.amount = function()
    return #class.array
  end

  class.list = function()
    local out = {}
    for i = 1, #class.array do
      table.insert(out, class.array[i])
    end
    return out
  end

  class.get = function(idx)
    return class.array[idx]
  end
  
  class.newPermID = function()
    class.permIDMax = class.permIDMax + 1
    return class.permIDMax
  end

  class.add = function(item)
    item.isValid = true
    table.insert(class.array, item)
  end

  class.sub = function(item)
    item.isValid = false
    table.remove(class.array, item.idx)
  end


  setmetatable(class, {
    __call = function(t, ...) return class.get(...) end,
    __len = function(t) return class.amount() end,
  })



  local function getItemIdx(item)
    if not item.isValid then return 0 end

    for idx = 1, #class.array do
      if class.array[idx] == item then
        return idx
      end
    end
  end

  class.mt = {
    __name = class.name,

    __eq = function(a, b)
      pp(a, b)
      return type(a) == type(b) and a.permID == b.permID
    end,

    __index = function(t, k)
      if k == 'idx' then
        getItemIdx(t)
      end
      return rawget(t, k)
    end,
  }
  return class
end