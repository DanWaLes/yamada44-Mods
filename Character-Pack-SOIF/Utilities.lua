
function NewIdentity()
	local data = Mod.PublicGameData;
	local ret = data.Identity or 1;
	data.Identity = ret + 1;
	Mod.PublicGameData = data;
	return ret;
end
function Dump(obj)
	if obj.proxyType ~= nil then
		DumpProxy(obj);
	elseif type(obj) == 'table' then
		DumpTable(obj);
	else
		print('Dump ' .. type(obj));
	end
end
function DumpTable(tbl)
    for k,v in pairs(tbl) do
        print('k = ' .. tostring(k) .. ' (' .. type(k) .. ') ' .. ' v = ' .. tostring(v) .. ' (' .. type(v) .. ')');
    end
end
function DumpProxy(obj)

    print('type=' .. obj.proxyType .. ' readOnly=' .. tostring(obj.readonly) .. ' readableKeys=' .. table.concat(obj.readableKeys, ',') .. ' writableKeys=' .. table.concat(obj.writableKeys, ','));
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end


function map(array, func)
	local new_array = {}
	local i = 1;
	for _,v in pairs(array) do
		new_array[i] = func(v);
		i = i + 1;
	end
	return new_array
end


function filter(array, func)
	local new_array = {}
	local i = 1;
	for _,v in pairs(array) do
		if (func(v)) then
			new_array[i] = v;
			i = i + 1;
		end
	end
	return new_array
end

function removeWhere(array, func)
	for k,v in pairs(array) do
		if (func(v)) then
			array[k] = nil;
		end
	end
end

function first(array, func)
	for _,v in pairs(array) do
		if (func == nil or func(v)) then
			return v;
		end
	end
	return nil;
end

function randomFromArray(array)
	local len = #array;
	local i = math.random(len);
	return array[i];
end

function startsWith(str, sub)
	return string.sub(str, 1, string.len(sub)) == sub;
end

function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

function groupBy(tbl, funcToGetKey)
	local ret = {};
	for k,v in pairs(tbl) do
		local key = funcToGetKey(v);
		local group = ret[key];
		if (group == nil) then
			group = {};
			ret[key] = group;
		end
		table.insert(group, v);
	end

	return ret;
end
function AbsoredDecider(attack, defence)
	local higher
	if attack > defence then higher = attack
	else higher = defence end

	print (higher,'higher')
	return higher
end

function Nonill(value)
	if value == nil then
		return 0
	
else return value end
end
function Iswhole(int)
	local compare = int / 2
	if math.floor(compare) ~= compare then return false 
else return true end

end
function Baseamount(value,dividor)
return value / dividor
	
end

function ModSign(returnvalue)
	local value

	if returnvalue == 0 then -- Mod call sign
		value = 'C&PL'
	elseif returnvalue == 1 then
		value = {}
		value[1] = 'White Walker'
		value[2] = 'Priest of R`hllor'
		value[3] = 'Kings Guard'
		value[4] = 'Night Watch'
		value[5] = 'Stark'
		value[6] = 'Random'
	end

	return value
end

function Filefinder(image)

	if image == 0 then image = math.random(1,5) end
	local filestorage = {}
	
		filestorage[1] = 'pack 1.a.png'
		filestorage[2] = 'pack 1.b.png'
		filestorage[3] = 'pack 1.c.png'
		filestorage[4] = 'pack 1.d.png'
		filestorage[5] = 'pack 1.e.png'
	
	return filestorage[image]
end