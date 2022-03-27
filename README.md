# Cheap-Parsing
Less resource-intensive parsing of gLua tables

```lua
local table = {
  ['Key1'] = 'Value1',
  ['Key2'] = 'Value2',
  ['Key3'] = 'Value3',
  ['Key4'] = 'Value4'
}

CheapParsing.ParseTable(table, function(key, value)
  print(key)
  print(value)
end)
```
