--------------------------------------------------------------------------------
-- wrap.lua bundle begins
-- version: 2020-09-04 6bd9a87
-- content sha256: 3f459084f0
--------------------------------------------------------------------------------
__lbs__version = "2020-09-04 6bd9a87"
do

    do
        local _ENV = _ENV
        package.preload["argparse"] = function(...)
            _ENV = _ENV;
            -- The MIT License (MIT)

            -- Copyright (c) 2013 - 2015 Peter Melnichenko

            -- Permission is hereby granted, free of charge, to any person obtaining a copy of
            -- this software and associated documentation files (the "Software"), to deal in
            -- the Software without restriction, including without limitation the rights to
            -- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
            -- the Software, and to permit persons to whom the Software is furnished to do so,
            -- subject to the following conditions:

            -- The above copyright notice and this permission notice shall be included in all
            -- copies or substantial portions of the Software.

            -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
            -- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
            -- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
            -- IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
            -- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

            local function deep_update(t1, t2)
                for k, v in pairs(t2) do
                    if type(v) == "table" then
                        v = deep_update({}, v)
                    end

                    t1[k] = v
                end

                return t1
            end

            -- A property is a tuple {name, callback}.
            -- properties.args is number of properties that can be set as arguments
            -- when calling an object.
            local function class(prototype, properties, parent)
                -- Class is the metatable of its instances.
                local cl = {}
                cl.__index = cl

                if parent then
                    cl.__prototype = deep_update(deep_update({}, parent.__prototype), prototype)
                else
                    cl.__prototype = prototype
                end

                if properties then
                    local names = {}

                    -- Create setter methods and fill set of property names. 
                    for _, property in ipairs(properties) do
                        local name, callback = property[1], property[2]

                        cl[name] = function(self, value)
                            if not callback(self, value) then
                                self["_" .. name] = value
                            end

                            return self
                        end

                        names[name] = true
                    end

                    function cl.__call(self, ...)
                        -- When calling an object, if the first argument is a table,
                        -- interpret keys as property names, else delegate arguments
                        -- to corresponding setters in order.
                        if type((...)) == "table" then
                            for name, value in pairs((...)) do
                                if names[name] then
                                    self[name](self, value)
                                end
                            end
                        else
                            local nargs = select("#", ...)

                            for i, property in ipairs(properties) do
                                if i > nargs or i > properties.args then
                                    break
                                end

                                local arg = select(i, ...)

                                if arg ~= nil then
                                    self[property[1]](self, arg)
                                end
                            end
                        end

                        return self
                    end
                end

                -- If indexing class fails, fallback to its parent.
                local class_metatable = {}
                class_metatable.__index = parent

                function class_metatable.__call(self, ...)
                    -- Calling a class returns its instance.
                    -- Arguments are delegated to the instance.
                    local object = deep_update({}, self.__prototype)
                    setmetatable(object, self)
                    return object(...)
                end

                return setmetatable(cl, class_metatable)
            end

            local function typecheck(name, types, value)
                for _, type_ in ipairs(types) do
                    if type(value) == type_ then
                        return true
                    end
                end

                error(("bad property '%s' (%s expected, got %s)"):format(name, table.concat(types, " or "), type(value)))
            end

            local function typechecked(name, ...)
                local types = {...}
                return {name, function(_, value)
                    typecheck(name, types, value)
                end}
            end

            local multiname = {"name", function(self, value)
                typecheck("name", {"string"}, value)

                for alias in value:gmatch("%S+") do
                    self._name = self._name or alias
                    table.insert(self._aliases, alias)
                end

                -- Do not set _name as with other properties.
                return true
            end}

            local function parse_boundaries(str)
                if tonumber(str) then
                    return tonumber(str), tonumber(str)
                end

                if str == "*" then
                    return 0, math.huge
                end

                if str == "+" then
                    return 1, math.huge
                end

                if str == "?" then
                    return 0, 1
                end

                if str:match "^%d+%-%d+$" then
                    local min, max = str:match "^(%d+)%-(%d+)$"
                    return tonumber(min), tonumber(max)
                end

                if str:match "^%d+%+$" then
                    local min = str:match "^(%d+)%+$"
                    return tonumber(min), math.huge
                end
            end

            local function boundaries(name)
                return {name, function(self, value)
                    typecheck(name, {"number", "string"}, value)

                    local min, max = parse_boundaries(value)

                    if not min then
                        error(("bad property '%s'"):format(name))
                    end

                    self["_min" .. name], self["_max" .. name] = min, max
                end}
            end

            local actions = {}

            local option_action = {"action", function(_, value)
                typecheck("action", {"function", "string"}, value)

                if type(value) == "string" and not actions[value] then
                    error(("unknown action '%s'"):format(value))
                end
            end}

            local option_init = {"init", function(self)
                self._has_init = true
            end}

            local option_default = {"default", function(self, value)
                if type(value) ~= "string" then
                    self._init = value
                    self._has_init = true
                    return true
                end
            end}

            local add_help = {"add_help", function(self, value)
                typecheck("add_help", {"boolean", "string", "table"}, value)

                if self._has_help then
                    table.remove(self._options)
                    self._has_help = false
                end

                if value then
                    local help = self:flag():description "Show this help message and exit.":action(
                                     function()
                            print(self:get_help())
                            os.exit(0)
                        end)

                    if value ~= true then
                        help = help(value)
                    end

                    if not help._name then
                        help "-h" "--help"
                    end

                    self._has_help = true
                end
            end}

            local Parser = class({
                _arguments = {},
                _options = {},
                _commands = {},
                _mutexes = {},
                _require_command = true,
                _handle_options = true
            }, {
                args = 3,
                typechecked("name", "string"),
                typechecked("description", "string"),
                typechecked("epilog", "string"),
                typechecked("usage", "string"),
                typechecked("help", "string"),
                typechecked("require_command", "boolean"),
                typechecked("handle_options", "boolean"),
                typechecked("action", "function"),
                typechecked("command_target", "string"),
                add_help
            })

            local Command = class({
                _aliases = {}
            }, {
                args = 3,
                multiname,
                typechecked("description", "string"),
                typechecked("epilog", "string"),
                typechecked("target", "string"),
                typechecked("usage", "string"),
                typechecked("help", "string"),
                typechecked("require_command", "boolean"),
                typechecked("handle_options", "boolean"),
                typechecked("action", "function"),
                typechecked("command_target", "string"),
                add_help
            }, Parser)

            local Argument = class({
                _minargs = 1,
                _maxargs = 1,
                _mincount = 1,
                _maxcount = 1,
                _defmode = "unused",
                _show_default = true
            }, {
                args = 5,
                typechecked("name", "string"),
                typechecked("description", "string"),
                option_default,
                typechecked("convert", "function", "table"),
                boundaries("args"),
                typechecked("target", "string"),
                typechecked("defmode", "string"),
                typechecked("show_default", "boolean"),
                typechecked("argname", "string", "table"),
                option_action,
                option_init
            })

            local Option = class({
                _aliases = {},
                _mincount = 0,
                _overwrite = true
            }, {
                args = 6,
                multiname,
                typechecked("description", "string"),
                option_default,
                typechecked("convert", "function", "table"),
                boundaries("args"),
                boundaries("count"),
                typechecked("target", "string"),
                typechecked("defmode", "string"),
                typechecked("show_default", "boolean"),
                typechecked("overwrite", "boolean"),
                typechecked("argname", "string", "table"),
                option_action,
                option_init
            }, Argument)

            function Argument:_get_argument_list()
                local buf = {}
                local i = 1

                while i <= math.min(self._minargs, 3) do
                    local argname = self:_get_argname(i)

                    if self._default and self._defmode:find "a" then
                        argname = "[" .. argname .. "]"
                    end

                    table.insert(buf, argname)
                    i = i + 1
                end

                while i <= math.min(self._maxargs, 3) do
                    table.insert(buf, "[" .. self:_get_argname(i) .. "]")
                    i = i + 1

                    if self._maxargs == math.huge then
                        break
                    end
                end

                if i < self._maxargs then
                    table.insert(buf, "...")
                end

                return buf
            end

            function Argument:_get_usage()
                local usage = table.concat(self:_get_argument_list(), " ")

                if self._default and self._defmode:find "u" then
                    if self._maxargs > 1 or (self._minargs == 1 and not self._defmode:find "a") then
                        usage = "[" .. usage .. "]"
                    end
                end

                return usage
            end

            function actions.store_true(result, target)
                result[target] = true
            end

            function actions.store_false(result, target)
                result[target] = false
            end

            function actions.store(result, target, argument)
                result[target] = argument
            end

            function actions.count(result, target, _, overwrite)
                if not overwrite then
                    result[target] = result[target] + 1
                end
            end

            function actions.append(result, target, argument, overwrite)
                result[target] = result[target] or {}
                table.insert(result[target], argument)

                if overwrite then
                    table.remove(result[target], 1)
                end
            end

            function actions.concat(result, target, arguments, overwrite)
                if overwrite then
                    error("'concat' action can't handle too many invocations")
                end

                result[target] = result[target] or {}

                for _, argument in ipairs(arguments) do
                    table.insert(result[target], argument)
                end
            end

            function Argument:_get_action()
                local action, init

                if self._maxcount == 1 then
                    if self._maxargs == 0 then
                        action, init = "store_true", nil
                    else
                        action, init = "store", nil
                    end
                else
                    if self._maxargs == 0 then
                        action, init = "count", 0
                    else
                        action, init = "append", {}
                    end
                end

                if self._action then
                    action = self._action
                end

                if self._has_init then
                    init = self._init
                end

                if type(action) == "string" then
                    action = actions[action]
                end

                return action, init
            end

            -- Returns placeholder for `narg`-th argument. 
            function Argument:_get_argname(narg)
                local argname = self._argname or self:_get_default_argname()

                if type(argname) == "table" then
                    return argname[narg]
                else
                    return argname
                end
            end

            function Argument:_get_default_argname()
                return "<" .. self._name .. ">"
            end

            function Option:_get_default_argname()
                return "<" .. self:_get_default_target() .. ">"
            end

            -- Returns label to be shown in the help message. 
            function Argument:_get_label()
                return self._name
            end

            function Option:_get_label()
                local variants = {}
                local argument_list = self:_get_argument_list()
                table.insert(argument_list, 1, nil)

                for _, alias in ipairs(self._aliases) do
                    argument_list[1] = alias
                    table.insert(variants, table.concat(argument_list, " "))
                end

                return table.concat(variants, ", ")
            end

            function Command:_get_label()
                return table.concat(self._aliases, ", ")
            end

            function Argument:_get_description()
                if self._default and self._show_default then
                    if self._description then
                        return ("%s (default: %s)"):format(self._description, self._default)
                    else
                        return ("default: %s"):format(self._default)
                    end
                else
                    return self._description or ""
                end
            end

            function Command:_get_description()
                return self._description or ""
            end

            function Option:_get_usage()
                local usage = self:_get_argument_list()
                table.insert(usage, 1, self._name)
                usage = table.concat(usage, " ")

                if self._mincount == 0 or self._default then
                    usage = "[" .. usage .. "]"
                end

                return usage
            end

            function Argument:_get_default_target()
                return self._name
            end

            function Option:_get_default_target()
                local res

                for _, alias in ipairs(self._aliases) do
                    if alias:sub(1, 1) == alias:sub(2, 2) then
                        res = alias:sub(3)
                        break
                    end
                end

                res = res or self._name:sub(2)
                return (res:gsub("-", "_"))
            end

            function Option:_is_vararg()
                return self._maxargs ~= self._minargs
            end

            function Parser:_get_fullname()
                local parent = self._parent
                local buf = {self._name}

                while parent do
                    table.insert(buf, 1, parent._name)
                    parent = parent._parent
                end

                return table.concat(buf, " ")
            end

            function Parser:_update_charset(charset)
                charset = charset or {}

                for _, command in ipairs(self._commands) do
                    command:_update_charset(charset)
                end

                for _, option in ipairs(self._options) do
                    for _, alias in ipairs(option._aliases) do
                        charset[alias:sub(1, 1)] = true
                    end
                end

                return charset
            end

            function Parser:argument(...)
                local argument = Argument(...)
                table.insert(self._arguments, argument)
                return argument
            end

            function Parser:option(...)
                local option = Option(...)

                if self._has_help then
                    table.insert(self._options, #self._options, option)
                else
                    table.insert(self._options, option)
                end

                return option
            end

            function Parser:flag(...)
                return self:option():args(0)(...)
            end

            function Parser:command(...)
                local command = Command():add_help(true)(...)
                command._parent = self
                table.insert(self._commands, command)
                return command
            end

            function Parser:mutex(...)
                local options = {...}

                for i, option in ipairs(options) do
                    assert(getmetatable(option) == Option, ("bad argument #%d to 'mutex' (Option expected)"):format(i))
                end

                table.insert(self._mutexes, options)
                return self
            end

            local max_usage_width = 70
            local usage_welcome = "Usage: "

            function Parser:get_usage()
                if self._usage then
                    return self._usage
                end

                local lines = {usage_welcome .. self:_get_fullname()}

                local function add(s)
                    if #lines[#lines] + 1 + #s <= max_usage_width then
                        lines[#lines] = lines[#lines] .. " " .. s
                    else
                        lines[#lines + 1] = (" "):rep(#usage_welcome) .. s
                    end
                end

                -- This can definitely be refactored into something cleaner
                local mutex_options = {}
                local vararg_mutexes = {}

                -- First, put mutexes which do not contain vararg options and remember those which do
                for _, mutex in ipairs(self._mutexes) do
                    local buf = {}
                    local is_vararg = false

                    for _, option in ipairs(mutex) do
                        if option:_is_vararg() then
                            is_vararg = true
                        end

                        table.insert(buf, option:_get_usage())
                        mutex_options[option] = true
                    end

                    local repr = "(" .. table.concat(buf, " | ") .. ")"

                    if is_vararg then
                        table.insert(vararg_mutexes, repr)
                    else
                        add(repr)
                    end
                end

                -- Second, put regular options
                for _, option in ipairs(self._options) do
                    if not mutex_options[option] and not option:_is_vararg() then
                        add(option:_get_usage())
                    end
                end

                -- Put positional arguments
                for _, argument in ipairs(self._arguments) do
                    add(argument:_get_usage())
                end

                -- Put mutexes containing vararg options
                for _, mutex_repr in ipairs(vararg_mutexes) do
                    add(mutex_repr)
                end

                for _, option in ipairs(self._options) do
                    if not mutex_options[option] and option:_is_vararg() then
                        add(option:_get_usage())
                    end
                end

                if #self._commands > 0 then
                    if self._require_command then
                        add("<command>")
                    else
                        add("[<command>]")
                    end

                    add("...")
                end

                return table.concat(lines, "\n")
            end

            local margin_len = 3
            local margin_len2 = 25
            local margin = (" "):rep(margin_len)
            local margin2 = (" "):rep(margin_len2)

            local function make_two_columns(s1, s2)
                if s2 == "" then
                    return margin .. s1
                end

                s2 = s2:gsub("\n", "\n" .. margin2)

                if #s1 < (margin_len2 - margin_len) then
                    return margin .. s1 .. (" "):rep(margin_len2 - margin_len - #s1) .. s2
                else
                    return margin .. s1 .. "\n" .. margin2 .. s2
                end
            end

            function Parser:get_help()
                if self._help then
                    return self._help
                end

                local blocks = {self:get_usage()}

                if self._description then
                    table.insert(blocks, self._description)
                end

                local labels = {"Arguments:", "Options:", "Commands:"}

                for i, elements in ipairs {self._arguments, self._options, self._commands} do
                    if #elements > 0 then
                        local buf = {labels[i]}

                        for _, element in ipairs(elements) do
                            table.insert(buf, make_two_columns(element:_get_label(), element:_get_description()))
                        end

                        table.insert(blocks, table.concat(buf, "\n"))
                    end
                end

                if self._epilog then
                    table.insert(blocks, self._epilog)
                end

                return table.concat(blocks, "\n\n")
            end

            local function get_tip(context, wrong_name)
                local context_pool = {}
                local possible_name
                local possible_names = {}

                for name in pairs(context) do
                    if type(name) == "string" then
                        for i = 1, #name do
                            possible_name = name:sub(1, i - 1) .. name:sub(i + 1)

                            if not context_pool[possible_name] then
                                context_pool[possible_name] = {}
                            end

                            table.insert(context_pool[possible_name], name)
                        end
                    end
                end

                for i = 1, #wrong_name + 1 do
                    possible_name = wrong_name:sub(1, i - 1) .. wrong_name:sub(i + 1)

                    if context[possible_name] then
                        possible_names[possible_name] = true
                    elseif context_pool[possible_name] then
                        for _, name in ipairs(context_pool[possible_name]) do
                            possible_names[name] = true
                        end
                    end
                end

                local first = next(possible_names)

                if first then
                    if next(possible_names, first) then
                        local possible_names_arr = {}

                        for name in pairs(possible_names) do
                            table.insert(possible_names_arr, "'" .. name .. "'")
                        end

                        table.sort(possible_names_arr)
                        return "\nDid you mean one of these: " .. table.concat(possible_names_arr, " ") .. "?"
                    else
                        return "\nDid you mean '" .. first .. "'?"
                    end
                else
                    return ""
                end
            end

            local ElementState = class({
                invocations = 0
            })

            function ElementState:__call(state, element)
                self.state = state
                self.result = state.result
                self.element = element
                self.target = element._target or element:_get_default_target()
                self.action, self.result[self.target] = element:_get_action()
                return self
            end

            function ElementState:error(fmt, ...)
                self.state:error(fmt, ...)
            end

            function ElementState:convert(argument)
                local converter = self.element._convert

                if converter then
                    local ok, err

                    if type(converter) == "function" then
                        ok, err = converter(argument)
                    else
                        ok = converter[argument]
                    end

                    if ok == nil then
                        self:error(err and "%s" or "malformed argument '%s'", err or argument)
                    end

                    argument = ok
                end

                return argument
            end

            function ElementState:default(mode)
                return self.element._defmode:find(mode) and self.element._default
            end

            local function bound(noun, min, max, is_max)
                local res = ""

                if min ~= max then
                    res = "at " .. (is_max and "most" or "least") .. " "
                end

                local number = is_max and max or min
                return res .. tostring(number) .. " " .. noun .. (number == 1 and "" or "s")
            end

            function ElementState:invoke(alias)
                self.open = true
                self.name = ("%s '%s'"):format(alias and "option" or "argument", alias or self.element._name)
                self.overwrite = false

                if self.invocations >= self.element._maxcount then
                    if self.element._overwrite then
                        self.overwrite = true
                    else
                        self:error("%s must be used %s", self.name,
                            bound("time", self.element._mincount, self.element._maxcount, true))
                    end
                else
                    self.invocations = self.invocations + 1
                end

                self.args = {}

                if self.element._maxargs <= 0 then
                    self:close()
                end

                return self.open
            end

            function ElementState:pass(argument)
                argument = self:convert(argument)
                table.insert(self.args, argument)

                if #self.args >= self.element._maxargs then
                    self:close()
                end

                return self.open
            end

            function ElementState:complete_invocation()
                while #self.args < self.element._minargs do
                    self:pass(self.element._default)
                end
            end

            function ElementState:close()
                if self.open then
                    self.open = false

                    if #self.args < self.element._minargs then
                        if self:default("a") then
                            self:complete_invocation()
                        else
                            if #self.args == 0 then
                                if getmetatable(self.element) == Argument then
                                    self:error("missing %s", self.name)
                                elseif self.element._maxargs == 1 then
                                    self:error("%s requires an argument", self.name)
                                end
                            end

                            self:error("%s requires %s", self.name,
                                bound("argument", self.element._minargs, self.element._maxargs))
                        end
                    end

                    local args = self.args

                    if self.element._maxargs <= 1 then
                        args = args[1]
                    end

                    if self.element._maxargs == 1 and self.element._minargs == 0 and self.element._mincount ~=
                        self.element._maxcount then
                        args = self.args
                    end

                    self.action(self.result, self.target, args, self.overwrite)
                end
            end

            local ParseState = class({
                result = {},
                options = {},
                arguments = {},
                argument_i = 1,
                element_to_mutexes = {},
                mutex_to_used_option = {},
                command_actions = {}
            })

            function ParseState:__call(parser, error_handler)
                self.parser = parser
                self.error_handler = error_handler
                self.charset = parser:_update_charset()
                self:switch(parser)
                return self
            end

            function ParseState:error(fmt, ...)
                self.error_handler(self.parser, fmt:format(...))
            end

            function ParseState:switch(parser)
                self.parser = parser

                if parser._action then
                    table.insert(self.command_actions, {
                        action = parser._action,
                        name = parser._name
                    })
                end

                for _, option in ipairs(parser._options) do
                    option = ElementState(self, option)
                    table.insert(self.options, option)

                    for _, alias in ipairs(option.element._aliases) do
                        self.options[alias] = option
                    end
                end

                for _, mutex in ipairs(parser._mutexes) do
                    for _, option in ipairs(mutex) do
                        if not self.element_to_mutexes[option] then
                            self.element_to_mutexes[option] = {}
                        end

                        table.insert(self.element_to_mutexes[option], mutex)
                    end
                end

                for _, argument in ipairs(parser._arguments) do
                    argument = ElementState(self, argument)
                    table.insert(self.arguments, argument)
                    argument:invoke()
                end

                self.handle_options = parser._handle_options
                self.argument = self.arguments[self.argument_i]
                self.commands = parser._commands

                for _, command in ipairs(self.commands) do
                    for _, alias in ipairs(command._aliases) do
                        self.commands[alias] = command
                    end
                end
            end

            function ParseState:get_option(name)
                local option = self.options[name]

                if not option then
                    self:error("unknown option '%s'%s", name, get_tip(self.options, name))
                else
                    return option
                end
            end

            function ParseState:get_command(name)
                local command = self.commands[name]

                if not command then
                    if #self.commands > 0 then
                        self:error("unknown command '%s'%s", name, get_tip(self.commands, name))
                    else
                        self:error("too many arguments: %s", name)
                    end
                else
                    return command
                end
            end

            function ParseState:invoke(option, name)
                self:close()

                if self.element_to_mutexes[option.element] then
                    for _, mutex in ipairs(self.element_to_mutexes[option.element]) do
                        local used_option = self.mutex_to_used_option[mutex]

                        if used_option and used_option ~= option then
                            self:error("option '%s' can not be used together with %s", name, used_option.name)
                        else
                            self.mutex_to_used_option[mutex] = option
                        end
                    end
                end

                if option:invoke(name) then
                    self.option = option
                end
            end

            function ParseState:pass(arg)
                if self.option then
                    if not self.option:pass(arg) then
                        self.option = nil
                    end
                elseif self.argument then
                    if not self.argument:pass(arg) then
                        self.argument_i = self.argument_i + 1
                        self.argument = self.arguments[self.argument_i]
                    end
                else
                    local command = self:get_command(arg)
                    self.result[command._target or command._name] = true

                    if self.parser._command_target then
                        self.result[self.parser._command_target] = command._name
                    end

                    self:switch(command)
                end
            end

            function ParseState:close()
                if self.option then
                    self.option:close()
                    self.option = nil
                end
            end

            function ParseState:finalize()
                self:close()

                for i = self.argument_i, #self.arguments do
                    local argument = self.arguments[i]
                    if #argument.args == 0 and argument:default("u") then
                        argument:complete_invocation()
                    else
                        argument:close()
                    end
                end

                if self.parser._require_command and #self.commands > 0 then
                    self:error("a command is required")
                end

                for _, option in ipairs(self.options) do
                    local name = option.name or ("option '%s'"):format(option.element._name)

                    if option.invocations == 0 then
                        if option:default("u") then
                            option:invoke(name)
                            option:complete_invocation()
                            option:close()
                        end
                    end

                    local mincount = option.element._mincount

                    if option.invocations < mincount then
                        if option:default("a") then
                            while option.invocations < mincount do
                                option:invoke(name)
                                option:close()
                            end
                        elseif option.invocations == 0 then
                            self:error("missing %s", name)
                        else
                            self:error("%s must be used %s", name, bound("time", mincount, option.element._maxcount))
                        end
                    end
                end

                for i = #self.command_actions, 1, -1 do
                    self.command_actions[i].action(self.result, self.command_actions[i].name)
                end
            end

            function ParseState:parse(args)
                for _, arg in ipairs(args) do
                    local plain = true

                    if self.handle_options then
                        local first = arg:sub(1, 1)

                        if self.charset[first] then
                            if #arg > 1 then
                                plain = false

                                if arg:sub(2, 2) == first then
                                    if #arg == 2 then
                                        self:close()
                                        self.handle_options = false
                                    else
                                        local equals = arg:find "="
                                        if equals then
                                            local name = arg:sub(1, equals - 1)
                                            local option = self:get_option(name)

                                            if option.element._maxargs <= 0 then
                                                self:error("option '%s' does not take arguments", name)
                                            end

                                            self:invoke(option, name)
                                            self:pass(arg:sub(equals + 1))
                                        else
                                            local option = self:get_option(arg)
                                            self:invoke(option, arg)
                                        end
                                    end
                                else
                                    for i = 2, #arg do
                                        local name = first .. arg:sub(i, i)
                                        local option = self:get_option(name)
                                        self:invoke(option, name)

                                        if i ~= #arg and option.element._maxargs > 0 then
                                            self:pass(arg:sub(i + 1))
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if plain then
                        self:pass(arg)
                    end
                end

                self:finalize()
                return self.result
            end

            function Parser:error(msg)
                io.stderr:write(("%s\n\nError: %s\n"):format(self:get_usage(), msg))
                os.exit(1)
            end

            -- Compatibility with strict.lua and other checkers:
            local default_cmdline = rawget(_G, "arg") or {}

            function Parser:_parse(args, error_handler)
                return ParseState(self, error_handler):parse(args or default_cmdline)
            end

            function Parser:parse(args)
                return self:_parse(args, self.error)
            end

            local function xpcall_error_handler(err)
                return tostring(err) .. "\noriginal " .. debug.traceback("", 2):sub(2)
            end

            function Parser:pparse(args)
                local parse_error

                local ok, result = xpcall(function()
                    return self:_parse(args, function(_, err)
                        parse_error = err
                        error(err, 0)
                    end)
                end, xpcall_error_handler)

                if ok then
                    return true, result
                elseif not parse_error then
                    error(result, 0)
                else
                    return false, parse_error
                end
            end

            return function(...)
                return Parser(default_cmdline[0]):add_help(true)(...)
            end

        end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.array.add"] = function(...)
            _ENV = _ENV;
            --- Creates a new array that has items from all argument arrays added in sequence.
            --- concat would be a better name, but there already is table.concat that does something else.
            ---@generic TItem
            ---@vararg TItem[]
            ---@return TItem[]
            local function add(...)
                local result = {}
                local arrays = {...}

                for arrayIndex = 1, #arrays do
                    local array = arrays[arrayIndex]

                    for elementIndex = 1, #array do
                        result[#result + 1] = array[elementIndex]
                    end
                end

                return result
            end

            return add

        end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.array.findOneMatching"] =
            function(...)
                _ENV = _ENV;
                --- Returns the first item matching the predicate.
                ---@generic TItem
                ---@param items TItem[]
                ---@param predicate fun(item:TItem):boolean
                ---@return TItem|nil, number|nil
                local function findOneMatching(items, predicate)
                    for index, item in ipairs(items) do
                        if predicate(item) then
                            return item, index
                        end
                    end
                end

                return findOneMatching

            end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.array.map"] = function(...)
            _ENV = _ENV;
            -- https://en.wikibooks.org/wiki/Lua_Functional_Programming/Functions

            ---@generic TSource, TResult
            ---@param array TSource[]
            ---@param func fun(item:TSource,index:number):TResult
            ---@return TResult[]
            local function map(array, func)
                local new_array = {}

                for index, value in ipairs(array) do
                    new_array[index] = func(value, index)
                end

                return new_array
            end

            return map

        end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.compat.pairs"] = function(...)
            _ENV = _ENV;
            -- adds __pairs support to Lua 5.1

            if not _ENV then
                local realPairs = pairs

                -- luacheck: ignore pairs
                pairs = function(tbl)
                    local mt = getmetatable(tbl)

                    if type(mt) == "table" and mt.__pairs then
                        return mt.__pairs(tbl)
                    else
                        return realPairs(tbl)
                    end
                end
            end

        end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.string.replaceVars"] =
            function(...)
                _ENV = _ENV;
                ---@param str string
                ---@param vars table<string, string>
                local function replaceVars(str, vars)
                    local result = str:gsub("({([^}]+)})", function(whole, key)
                        return vars[key] or whole
                    end)

                    return result
                end

                return replaceVars

            end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.table.OrderedMap"] = function(...)
            _ENV = _ENV;
            -- Penlight's OrderedMap adds over 150 KB of Lua code. This class implements some of its functionality.

            local getValueKey = require "common.utils.table.getValueKey"

            local concat = table.concat

            local function iterateOrderedMap(om, key)
                if key == nil then
                    key = om._keys[1]
                else
                    local keyIndex = getValueKey(om._keys, key)
                    if not keyIndex then
                        return nil
                    end
                    key = om._keys[keyIndex + 1]
                end

                return key, om[key]
            end

            local OrderedMap = {}
            OrderedMap.__index = OrderedMap

            function OrderedMap.new(t)
                local self = setmetatable({
                    _keys = {}
                }, OrderedMap)
                if t then
                    self:update(t)
                end
                return self
            end

            function OrderedMap:update(t)
                if #t > 0 then
                    for _, pair in ipairs(t) do
                        local k, v = next(pair)
                        if not k then
                            error("Empty pair (key is null).")
                        end
                        self[k] = v
                    end
                else
                    for k, v in pairs(t) do
                        self[k] = v
                    end
                end

                return self
            end

            function OrderedMap:__pairs()
                return iterateOrderedMap, self, nil
            end

            function OrderedMap._ipairs()
                error("Not implemented!")
            end

            function OrderedMap:__newindex(k, v)
                local keys = self._keys

                if not getValueKey(keys, v) then
                    keys[#keys + 1] = k
                end

                rawset(self, k, v)
            end

            function OrderedMap:__tostring() -- for debugging and unit testing
                local keys = self._keys
                local buf = {"{"}

                for i = 1, #keys do
                    local k = keys[i]
                    local v = self[k]

                    buf[#buf + 1] = k
                    buf[#buf + 1] = "="

                    if type(v) == "number" then
                        buf[#buf + 1] = v
                    else
                        buf[#buf + 1] = '"' .. tostring(v) .. '"'
                    end

                    if i < #keys then
                        buf[#buf + 1] = ","
                    end
                end

                buf[#buf + 1] = "}"
                return concat(buf)
            end

            return setmetatable({}, {
                __call = function(_, t)
                    return OrderedMap.new(t)
                end,
                __index = OrderedMap
            })

        end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.table.assign"] = function(...)
            _ENV = _ENV;
            -- Copies values of source tables into the target table and returns the target table
            -- (like JavaScript's Object.assign)

            ---@generic TTargetTable, TCopiedTable
            ---@param targetTable TTargetTable
            ---@vararg TCopiedTable
            ---@return TTargetTable | TCopiedTable
            local function assign(targetTable, ...)
                local sourceTables = {...}

                for i = 1, #sourceTables do
                    for key, value in pairs(sourceTables[i]) do
                        targetTable[key] = value
                    end
                end

                return targetTable
            end

            return assign

        end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.table.getKeys"] = function(...)
            _ENV = _ENV;
            ---@generic TKey
            ---@param tbl table<TKey, any>
            ---@return TKey[]
            local function getKeys(tbl)
                local keys = {}

                for key, _ in pairs(tbl) do
                    keys[#keys + 1] = key
                end

                return keys
            end

            return getKeys

        end
    end

    do
        local _ENV = _ENV
        package.preload["common.utils.table.getValueKey"] = function(...)
            _ENV = _ENV;
            ---@generic TKey, TValue
            ---@param tbl table<TKey, TValue>
            ---@param valueToFind TValue
            ---@return TValue
            local function getValueKey(tbl, valueToFind)
                for key, value in pairs(tbl) do
                    if value == valueToFind then
                        return key
                    end
                end

                return nil
            end

            return getValueKey

        end
    end

    do
        local _ENV = _ENV
        package.preload["dkjson"] = function(...)
            _ENV = _ENV;
            -- Module options:
            local always_try_using_lpeg = true
            local register_global_module_table = false
            local global_module_name = 'json'

            --[==[

David Kolf's JSON module for Lua 5.1/5.2

Version 2.5


For the documentation see the corresponding readme.txt or visit
<http://dkolf.de/src/dkjson-lua.fsl/>.

You can contact the author by sending an e-mail to 'david' at the
domain 'dkolf.de'.


Copyright (C) 2010-2013 David Heiko Kolf

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]==]

            -- global dependencies:
            local pairs, type, tostring, tonumber, getmetatable, setmetatable, rawset = pairs, type, tostring, tonumber,
                getmetatable, setmetatable, rawset
            local error, require, pcall, select = error, require, pcall, select
            local floor, huge = math.floor, math.huge
            local strrep, gsub, strsub, strbyte, strchar, strfind, strlen, strformat = string.rep, string.gsub,
                string.sub, string.byte, string.char, string.find, string.len, string.format
            local strmatch = string.match
            local concat = table.concat

            local json = {
                version = "dkjson 2.5"
            }

            if register_global_module_table then
                _G[global_module_name] = json
            end

            local _ENV = nil -- blocking globals in Lua 5.2

            pcall(function()
                -- Enable access to blocked metatables.
                -- Don't worry, this module doesn't change anything in them.
                local debmeta = require"debug".getmetatable
                if debmeta then
                    getmetatable = debmeta
                end
            end)

            json.null = setmetatable({}, {
                __tojson = function()
                    return "null"
                end
            })

            local function isarray(tbl)
                local max, n, arraylen = 0, 0, 0
                for k, v in pairs(tbl) do
                    if k == 'n' and type(v) == 'number' then
                        arraylen = v
                        if v > max then
                            max = v
                        end
                    else
                        if type(k) ~= 'number' or k < 1 or floor(k) ~= k then
                            return false
                        end
                        if k > max then
                            max = k
                        end
                        n = n + 1
                    end
                end
                if max > 10 and max > arraylen and max > n * 2 then
                    return false -- don't create an array with too many holes
                end
                return true, max
            end

            local escapecodes = {
                ["\""] = "\\\"",
                ["\\"] = "\\\\",
                ["\b"] = "\\b",
                ["\f"] = "\\f",
                ["\n"] = "\\n",
                ["\r"] = "\\r",
                ["\t"] = "\\t"
            }

            local function escapeutf8(uchar)
                local value = escapecodes[uchar]
                if value then
                    return value
                end
                local a, b, c, d = strbyte(uchar, 1, 4)
                a, b, c, d = a or 0, b or 0, c or 0, d or 0
                if a <= 0x7f then
                    value = a
                elseif 0xc0 <= a and a <= 0xdf and b >= 0x80 then
                    value = (a - 0xc0) * 0x40 + b - 0x80
                elseif 0xe0 <= a and a <= 0xef and b >= 0x80 and c >= 0x80 then
                    value = ((a - 0xe0) * 0x40 + b - 0x80) * 0x40 + c - 0x80
                elseif 0xf0 <= a and a <= 0xf7 and b >= 0x80 and c >= 0x80 and d >= 0x80 then
                    value = (((a - 0xf0) * 0x40 + b - 0x80) * 0x40 + c - 0x80) * 0x40 + d - 0x80
                else
                    return ""
                end
                if value <= 0xffff then
                    return strformat("\\u%.4x", value)
                elseif value <= 0x10ffff then
                    -- encode as UTF-16 surrogate pair
                    value = value - 0x10000
                    local highsur, lowsur = 0xD800 + floor(value / 0x400), 0xDC00 + (value % 0x400)
                    return strformat("\\u%.4x\\u%.4x", highsur, lowsur)
                else
                    return ""
                end
            end

            local function fsub(str, pattern, repl)
                -- gsub always builds a new string in a buffer, even when no match
                -- exists. First using find should be more efficient when most strings
                -- don't contain the pattern.
                if strfind(str, pattern) then
                    return gsub(str, pattern, repl)
                else
                    return str
                end
            end

            local function quotestring(value)
                -- based on the regexp "escapable" in https://github.com/douglascrockford/JSON-js
                value = fsub(value, "[%z\1-\31\"\\\127]", escapeutf8)
                if strfind(value, "[\194\216\220\225\226\239]") then
                    value = fsub(value, "\194[\128-\159\173]", escapeutf8)
                    value = fsub(value, "\216[\128-\132]", escapeutf8)
                    value = fsub(value, "\220\143", escapeutf8)
                    value = fsub(value, "\225\158[\180\181]", escapeutf8)
                    value = fsub(value, "\226\128[\140-\143\168-\175]", escapeutf8)
                    value = fsub(value, "\226\129[\160-\175]", escapeutf8)
                    value = fsub(value, "\239\187\191", escapeutf8)
                    value = fsub(value, "\239\191[\176-\191]", escapeutf8)
                end
                return "\"" .. value .. "\""
            end
            json.quotestring = quotestring

            local function replace(str, o, n)
                local i, j = strfind(str, o, 1, true)
                if i then
                    return strsub(str, 1, i - 1) .. n .. strsub(str, j + 1, -1)
                else
                    return str
                end
            end

            -- locale independent num2str and str2num functions
            local decpoint, numfilter

            local function updatedecpoint()
                decpoint = strmatch(tostring(0.5), "([^05+])")
                -- build a filter that can be used to remove group separators
                numfilter = "[^0-9%-%+eE" .. gsub(decpoint, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "]+"
            end

            updatedecpoint()

            local function num2str(num)
                return replace(fsub(tostring(num), numfilter, ""), decpoint, ".")
            end

            local function str2num(str)
                local num = tonumber(replace(str, ".", decpoint))
                if not num then
                    updatedecpoint()
                    num = tonumber(replace(str, ".", decpoint))
                end
                return num
            end

            local function addnewline2(level, buffer, buflen)
                buffer[buflen + 1] = "\n"
                buffer[buflen + 2] = strrep("  ", level)
                buflen = buflen + 2
                return buflen
            end

            function json.addnewline(state)
                if state.indent then
                    state.bufferlen = addnewline2(state.level or 0, state.buffer, state.bufferlen or #(state.buffer))
                end
            end

            local encode2
            local function addpair(key, value, prev, indent, level, buffer, buflen, tables, globalorder, state)
                local kt = type(key)
                if kt ~= 'string' and kt ~= 'number' then
                    return nil, "type '" .. kt .. "' is not supported as a key by JSON."
                end
                if prev then
                    buflen = buflen + 1
                    buffer[buflen] = ","
                end
                if indent then
                    buflen = addnewline2(level, buffer, buflen)
                end
                buffer[buflen + 1] = quotestring(key)
                buffer[buflen + 2] = ":"
                return encode2(value, indent, level, buffer, buflen + 2, tables, globalorder, state)
            end

            local function appendcustom(res, buffer, state)
                local buflen = state.bufferlen
                if type(res) == 'string' then
                    buflen = buflen + 1
                    buffer[buflen] = res
                end
                return buflen
            end

            local function exception(reason, value, state, buffer, buflen, defaultmessage)
                defaultmessage = defaultmessage or reason
                local handler = state.exception
                if not handler then
                    return nil, defaultmessage
                else
                    state.bufferlen = buflen
                    local ret, msg = handler(reason, value, state, defaultmessage)
                    if not ret then
                        return nil, msg or defaultmessage
                    end
                    return appendcustom(ret, buffer, state)
                end
            end

            function json.encodeexception(reason, value, state, defaultmessage)
                return quotestring("<" .. defaultmessage .. ">")
            end

            encode2 = function(value, indent, level, buffer, buflen, tables, globalorder, state)
                local valtype = type(value)
                local valmeta = getmetatable(value)
                valmeta = type(valmeta) == 'table' and valmeta -- only tables
                
                local valtojson = valmeta and valmeta.__tojson
                if valtojson then
                    if tables[value] then
                        return exception('reference cycle', value, state, buffer, buflen)
                    end
                    tables[value] = true
                    state.bufferlen = buflen
                    local ret, msg = valtojson(value, state)
                    if not ret then
                        return exception('custom encoder failed', value, state, buffer, buflen, msg)
                    end
                    tables[value] = nil
                    buflen = appendcustom(ret, buffer, state)
                elseif value == nil then
                    buflen = buflen + 1
                    buffer[buflen] = "null"
                elseif valtype == 'number' then
                    local s
                    if value ~= value or value >= huge or -value >= huge then
                        -- This is the behaviour of the original JSON implementation.
                        s = "null"
                    else
                        s = num2str(value)
                    end
                    buflen = buflen + 1
                    buffer[buflen] = s
                elseif valtype == 'boolean' then
                    buflen = buflen + 1
                    buffer[buflen] = value and "true" or "false"
                elseif valtype == 'string' then
                    buflen = buflen + 1
                    buffer[buflen] = quotestring(value)
                elseif valtype == 'table' then
                    if tables[value] then
                        return exception('reference cycle', value, state, buffer, buflen)
                    end
                    tables[value] = true
                    level = level + 1
                    local isa, n = isarray(value)
                    if n == 0 and valmeta and valmeta.__jsontype == 'object' then
                        isa = false
                    end
                    local msg
                    if isa then -- JSON array
                        buflen = buflen + 1
                        buffer[buflen] = "["
                        for i = 1, n do
                            buflen, msg = encode2(value[i], indent, level, buffer, buflen, tables, globalorder, state)
                            if not buflen then
                                return nil, msg
                            end
                            if i < n then
                                buflen = buflen + 1
                                buffer[buflen] = ","
                            end
                        end
                        buflen = buflen + 1
                        buffer[buflen] = "]"
                    else -- JSON object
                        local prev = false
                        buflen = buflen + 1
                        buffer[buflen] = "{"
                        local order = valmeta and valmeta.__jsonorder or globalorder
                        if order then
                            local used = {}
                            n = #order
                            for i = 1, n do
                                local k = order[i]
                                local v = value[k]
                                if v then
                                    used[k] = true
                                    buflen, msg = addpair(k, v, prev, indent, level, buffer, buflen, tables,
                                                      globalorder, state)
                                    prev = true -- add a seperator before the next element
                                end
                            end
                            for k, v in pairs(value) do
                                if not used[k] then
                                    buflen, msg = addpair(k, v, prev, indent, level, buffer, buflen, tables,
                                                      globalorder, state)
                                    if not buflen then
                                        return nil, msg
                                    end
                                    prev = true -- add a seperator before the next element
                                end
                            end
                        else -- unordered
                            for k, v in pairs(value) do
                                buflen, msg = addpair(k, v, prev, indent, level, buffer, buflen, tables, globalorder,
                                                  state)
                                if not buflen then
                                    return nil, msg
                                end
                                prev = true -- add a seperator before the next element
                            end
                        end
                        if indent then
                            buflen = addnewline2(level - 1, buffer, buflen)
                        end
                        buflen = buflen + 1
                        buffer[buflen] = "}"
                    end
                    tables[value] = nil
                else
                    return exception('unsupported type', value, state, buffer, buflen,
                               "type '" .. valtype .. "' is not supported by JSON.")
                end
                return buflen
            end

            function json.encode(value, state)
                state = state or {}
                local oldbuffer = state.buffer
                local buffer = oldbuffer or {}
                state.buffer = buffer
                updatedecpoint()
                local ret, msg = encode2(value, state.indent, state.level or 0, buffer, state.bufferlen or 0,
                                     state.tables or {}, state.keyorder, state)
                if not ret then
                    error(msg, 2)
                elseif oldbuffer == buffer then
                    state.bufferlen = ret
                    return true
                else
                    state.bufferlen = nil
                    state.buffer = nil
                    return concat(buffer)
                end
            end

            local function loc(str, where)
                local line, pos, linepos = 1, 1, 0
                while true do
                    pos = strfind(str, "\n", pos, true)
                    if pos and pos < where then
                        line = line + 1
                        linepos = pos
                        pos = pos + 1
                    else
                        break
                    end
                end
                return "line " .. line .. ", column " .. (where - linepos)
            end

            local function unterminated(str, what, where)
                return nil, strlen(str) + 1, "unterminated " .. what .. " at " .. loc(str, where)
            end

            local function scanwhite(str, pos)
                while true do
                    pos = strfind(str, "%S", pos)
                    if not pos then
                        return nil
                    end
                    local sub2 = strsub(str, pos, pos + 1)
                    if sub2 == "\239\187" and strsub(str, pos + 2, pos + 2) == "\191" then
                        -- UTF-8 Byte Order Mark
                        pos = pos + 3
                    elseif sub2 == "//" then
                        pos = strfind(str, "[\n\r]", pos + 2)
                        if not pos then
                            return nil
                        end
                    elseif sub2 == "/*" then
                        pos = strfind(str, "*/", pos + 2)
                        if not pos then
                            return nil
                        end
                        pos = pos + 2
                    else
                        return pos
                    end
                end
            end

            local escapechars = {
                ["\""] = "\"",
                ["\\"] = "\\",
                ["/"] = "/",
                ["b"] = "\b",
                ["f"] = "\f",
                ["n"] = "\n",
                ["r"] = "\r",
                ["t"] = "\t"
            }

            local function unichar(value)
                if value < 0 then
                    return nil
                elseif value <= 0x007f then
                    return strchar(value)
                elseif value <= 0x07ff then
                    return strchar(0xc0 + floor(value / 0x40), 0x80 + (floor(value) % 0x40))
                elseif value <= 0xffff then
                    return strchar(0xe0 + floor(value / 0x1000), 0x80 + (floor(value / 0x40) % 0x40),
                               0x80 + (floor(value) % 0x40))
                elseif value <= 0x10ffff then
                    return strchar(0xf0 + floor(value / 0x40000), 0x80 + (floor(value / 0x1000) % 0x40),
                               0x80 + (floor(value / 0x40) % 0x40), 0x80 + (floor(value) % 0x40))
                else
                    return nil
                end
            end

            local function scanstring(str, pos)
                local lastpos = pos + 1
                local buffer, n = {}, 0
                while true do
                    local nextpos = strfind(str, "[\"\\]", lastpos)
                    if not nextpos then
                        return unterminated(str, "string", pos)
                    end
                    if nextpos > lastpos then
                        n = n + 1
                        buffer[n] = strsub(str, lastpos, nextpos - 1)
                    end
                    if strsub(str, nextpos, nextpos) == "\"" then
                        lastpos = nextpos + 1
                        break
                    else
                        local escchar = strsub(str, nextpos + 1, nextpos + 1)
                        local value
                        if escchar == "u" then
                            value = tonumber(strsub(str, nextpos + 2, nextpos + 5), 16)
                            if value then
                                local value2
                                if 0xD800 <= value and value <= 0xDBff then
                                    -- we have the high surrogate of UTF-16. Check if there is a
                                    -- low surrogate escaped nearby to combine them.
                                    if strsub(str, nextpos + 6, nextpos + 7) == "\\u" then
                                        value2 = tonumber(strsub(str, nextpos + 8, nextpos + 11), 16)
                                        if value2 and 0xDC00 <= value2 and value2 <= 0xDFFF then
                                            value = (value - 0xD800) * 0x400 + (value2 - 0xDC00) + 0x10000
                                        else
                                            value2 = nil -- in case it was out of range for a low surrogate
                                        end
                                    end
                                end
                                value = value and unichar(value)
                                if value then
                                    if value2 then
                                        lastpos = nextpos + 12
                                    else
                                        lastpos = nextpos + 6
                                    end
                                end
                            end
                        end
                        if not value then
                            value = escapechars[escchar] or escchar
                            lastpos = nextpos + 2
                        end
                        n = n + 1
                        buffer[n] = value
                    end
                end
                if n == 1 then
                    return buffer[1], lastpos
                elseif n > 1 then
                    return concat(buffer), lastpos
                else
                    return "", lastpos
                end
            end

            local scanvalue
            local function scantable(what, closechar, str, startpos, nullval, objectmeta, arraymeta)
                local len = strlen(str)
                local tbl, n = {}, 0
                local pos = startpos + 1
                if what == 'object' then
                    setmetatable(tbl, objectmeta)
                else
                    setmetatable(tbl, arraymeta)
                end
                while true do
                    pos = scanwhite(str, pos)
                    if not pos then
                        return unterminated(str, what, startpos)
                    end
                    local char = strsub(str, pos, pos)
                    if char == closechar then
                        return tbl, pos + 1
                    end
                    local val1, err
                    val1, pos, err = scanvalue(str, pos, nullval, objectmeta, arraymeta)
                    if err then
                        return nil, pos, err
                    end
                    pos = scanwhite(str, pos)
                    if not pos then
                        return unterminated(str, what, startpos)
                    end
                    char = strsub(str, pos, pos)
                    if char == ":" then
                        if val1 == nil then
                            return nil, pos, "cannot use nil as table index (at " .. loc(str, pos) .. ")"
                        end
                        pos = scanwhite(str, pos + 1)
                        if not pos then
                            return unterminated(str, what, startpos)
                        end
                        local val2
                        val2, pos, err = scanvalue(str, pos, nullval, objectmeta, arraymeta)
                        if err then
                            return nil, pos, err
                        end
                        tbl[val1] = val2
                        pos = scanwhite(str, pos)
                        if not pos then
                            return unterminated(str, what, startpos)
                        end
                        char = strsub(str, pos, pos)
                    else
                        n = n + 1
                        tbl[n] = val1
                    end
                    if char == "," then
                        pos = pos + 1
                    end
                end
            end

            scanvalue = function(str, pos, nullval, objectmeta, arraymeta)
                pos = pos or 1
                pos = scanwhite(str, pos)
                if not pos then
                    return nil, strlen(str) + 1, "no valid JSON value (reached the end)"
                end
                local char = strsub(str, pos, pos)
                if char == "{" then
                    return scantable('object', "}", str, pos, nullval, objectmeta, arraymeta)
                elseif char == "[" then
                    return scantable('array', "]", str, pos, nullval, objectmeta, arraymeta)
                elseif char == "\"" then
                    return scanstring(str, pos)
                else
                    local pstart, pend = strfind(str, "^%-?[%d%.]+[eE]?[%+%-]?%d*", pos)
                    if pstart then
                        local number = str2num(strsub(str, pstart, pend))
                        if number then
                            return number, pend + 1
                        end
                    end
                    pstart, pend = strfind(str, "^%a%w*", pos)
                    if pstart then
                        local name = strsub(str, pstart, pend)
                        if name == "true" then
                            return true, pend + 1
                        elseif name == "false" then
                            return false, pend + 1
                        elseif name == "null" then
                            return nullval, pend + 1
                        end
                    end
                    return nil, pos, "no valid JSON value at " .. loc(str, pos)
                end
            end

            local function optionalmetatables(...)
                if select("#", ...) > 0 then
                    return ...
                else
                    return {
                        __jsontype = 'object'
                    }, {
                        __jsontype = 'array'
                    }
                end
            end

            function json.decode(str, pos, nullval, ...)
                local objectmeta, arraymeta = optionalmetatables(...)
                return scanvalue(str, pos, nullval, objectmeta, arraymeta)
            end

            function json.use_lpeg()
                local g = require("lpeg")

                if g.version() == "0.11" then
                    error "due to a bug in LPeg 0.11, it cannot be used for JSON matching"
                end

                local pegmatch = g.match
                local P, S, R = g.P, g.S, g.R

                local function ErrorCall(str, pos, msg, state)
                    if not state.msg then
                        state.msg = msg .. " at " .. loc(str, pos)
                        state.pos = pos
                    end
                    return false
                end

                local function Err(msg)
                    return g.Cmt(g.Cc(msg) * g.Carg(2), ErrorCall)
                end

                local SingleLineComment = P "//" * (1 - S "\n\r") ^ 0
                local MultiLineComment = P "/*" * (1 - P "*/") ^ 0 * P "*/"
                local Space = (S " \n\r\t" + P "\239\187\191" + SingleLineComment + MultiLineComment) ^ 0

                local PlainChar = 1 - S "\"\\\n\r"
                local EscapeSequence = (P "\\" * g.C(S "\"\\/bfnrt" + Err "unsupported escape sequence")) / escapechars
                local HexDigit = R("09", "af", "AF")
                local function UTF16Surrogate(match, pos, high, low)
                    high, low = tonumber(high, 16), tonumber(low, 16)
                    if 0xD800 <= high and high <= 0xDBff and 0xDC00 <= low and low <= 0xDFFF then
                        return true, unichar((high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000)
                    else
                        return false
                    end
                end
                local function UTF16BMP(hex)
                    return unichar(tonumber(hex, 16))
                end
                local U16Sequence = (P "\\u" * g.C(HexDigit * HexDigit * HexDigit * HexDigit))
                local UnicodeEscape = g.Cmt(U16Sequence * U16Sequence, UTF16Surrogate) + U16Sequence / UTF16BMP
                local Char = UnicodeEscape + EscapeSequence + PlainChar
                local String = P "\"" * g.Cs(Char ^ 0) * (P "\"" + Err "unterminated string")
                local Integer = P "-" ^ (-1) * (P "0" + (R "19" * R "09" ^ 0))
                local Fractal = P "." * R "09" ^ 0
                local Exponent = (S "eE") * (S "+-") ^ (-1) * R "09" ^ 1
                local Number = (Integer * Fractal ^ (-1) * Exponent ^ (-1)) / str2num
                local Constant = P "true" * g.Cc(true) + P "false" * g.Cc(false) + P "null" * g.Carg(1)
                local SimpleValue = Number + String + Constant
                local ArrayContent, ObjectContent

                -- The functions parsearray and parseobject parse only a single value/pair
                -- at a time and store them directly to avoid hitting the LPeg limits.
                local function parsearray(str, pos, nullval, state)
                    local obj, cont
                    local npos
                    local t, nt = {}, 0
                    repeat
                        obj, cont, npos = pegmatch(ArrayContent, str, pos, nullval, state)
                        if not npos then
                            break
                        end
                        pos = npos
                        nt = nt + 1
                        t[nt] = obj
                    until cont == 'last'
                    return pos, setmetatable(t, state.arraymeta)
                end

                local function parseobject(str, pos, nullval, state)
                    local obj, key, cont
                    local npos
                    local t = {}
                    repeat
                        key, obj, cont, npos = pegmatch(ObjectContent, str, pos, nullval, state)
                        if not npos then
                            break
                        end
                        pos = npos
                        t[key] = obj
                    until cont == 'last'
                    return pos, setmetatable(t, state.objectmeta)
                end

                local Array = P "[" * g.Cmt(g.Carg(1) * g.Carg(2), parsearray) * Space * (P "]" + Err "']' expected")
                local Object = P "{" * g.Cmt(g.Carg(1) * g.Carg(2), parseobject) * Space * (P "}" + Err "'}' expected")
                local Value = Space * (Array + Object + SimpleValue)
                local ExpectedValue = Value + Space * Err "value expected"
                ArrayContent = Value * Space * (P "," * g.Cc 'cont' + g.Cc 'last') * g.Cp()
                local Pair = g.Cg(Space * String * Space * (P ":" + Err "colon expected") * ExpectedValue)
                ObjectContent = Pair * Space * (P "," * g.Cc 'cont' + g.Cc 'last') * g.Cp()
                local DecodeValue = ExpectedValue * g.Cp()

                function json.decode(str, pos, nullval, ...)
                    local state = {}
                    state.objectmeta, state.arraymeta = optionalmetatables(...)
                    local obj, retpos = pegmatch(DecodeValue, str, pos, nullval, state)
                    if state.msg then
                        return nil, state.pos, state.msg
                    else
                        return obj, retpos
                    end
                end

                -- use this function only once:
                json.use_lpeg = function()
                    return json
                end

                json.using_lpeg = true

                return json -- so you can get the module using json = require "dkjson".use_lpeg()
                
            end

            if always_try_using_lpeg then
                pcall(json.use_lpeg)
            end

            return json

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.Autoconf"] = function(...)
            _ENV = _ENV;
            local findOneMatching = require "common.utils.array.findOneMatching"
            local AutoconfSlot = require "du.script-config.AutoconfSlot"

            local insert, unpack = table.insert, unpack or table.unpack -- luacheck: ignore unpack
            
            ---@param name string
            local function createAutoconf(name)
                name = name or "Unnamed autoconf"

                local self = {} ---@class ScriptAutoconf

                ---@type ScriptAutoconfSlot[]
                local slots = {AutoconfSlot.new("unit", "control", nil, nil, true),
                               AutoconfSlot.new("system", "system", nil, nil, true),
                               AutoconfSlot.new("library", "library", nil, nil, true)}

                ---@param slotName string
                ---@param slotTypeName string
                ---@param slotClass string
                ---@param slotSelect string|nil
                function self.addSlot(slotName, slotTypeName, slotClass, slotSelect)
                    local slot = AutoconfSlot.new(slotName, slotTypeName, slotClass, slotSelect)
                    insert(slots, slot)
                    return slot
                end

                ---@return ScriptAutoconfSlot[]
                function self.getSlots()
                    return {unpack(slots)}
                end

                ---@param slotName string
                function self.getSlotByName(slotName)
                    return findOneMatching(slots, function(slot)
                        return slot.getName() == slotName
                    end)
                end

                function self.getName()
                    return name
                end

                ---@param newName string
                function self.setName(newName)
                    name = newName
                end

                return self
            end

            return {
                new = createAutoconf
            }

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.AutoconfSlot"] = function(...)
            _ENV = _ENV;
            local Handler = require "du.script-config.Handler"

            local insert, unpack = table.insert, unpack or table.unpack -- luacheck: ignore unpack
            
            local function createAutoconfSlot(name, typeName, class, select, isBuiltin)
                local self = {} ---@class ScriptAutoconfSlot

                local handlers = {} ---@type ScriptHandler[]

                function self.getName()
                    return name
                end

                function self.getTypeName()
                    return typeName
                end

                function self.getClass()
                    return class
                end

                function self.getSelect()
                    return select
                end

                function self.getIsBuiltin()
                    return isBuiltin
                end

                function self.addHandler(filterSignature, filterArguments, code)
                    local handler = Handler.new(filterSignature, filterArguments, code)
                    insert(handlers, handler)
                    return handler
                end

                ---@return ScriptHandler[]
                function self.getHandlers()
                    return {unpack(handlers)}
                end

                return self
            end

            return {
                new = createAutoconfSlot
            }

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.Config"] = function(...)
            _ENV = _ENV;
            local map = require "common.utils.array.map"
            local findOneMatching = require "common.utils.array.findOneMatching"
            local ConfigMethod = require "du.script-config.ConfigMethod"
            local ConfigSlot = require "du.script-config.ConfigSlot"

            local insert, unpack = table.insert, unpack or table.unpack -- luacheck: ignore unpack
            
            local function createConfig()
                local self = {} ---@class ScriptConfig

                local slots = {} ---@type ScriptConfigSlot[]
                local methods = {} ---@type ScriptConfigMethod[]

                ---@param slotKey number
                ---@param slotName string
                ---@param slotElementType string
                function self.addSlot(slotKey, slotName, slotElementType)
                    local slot = ConfigSlot.new(slotKey, slotName, slotElementType)
                    insert(slots, slot)
                    return slot
                end

                ---@param signature string
                ---@param code string
                function self.addMethod(signature, code)
                    local method = ConfigMethod.new(signature, code)
                    insert(methods, method)
                    return method
                end

                ---@return ScriptConfigSlot[]
                function self.getSlots()
                    return {unpack(slots)}
                end

                function self.getSlotKeys()
                    return map(slots, function(slot)
                        return slot.getKey()
                    end)
                end

                function self.getSlotByKey(slotKey)
                    return findOneMatching(slots, function(slot)
                        return slot.getKey() == slotKey
                    end)
                end

                function self.getSlotByName(slotName)
                    return findOneMatching(slots, function(slot)
                        return slot.getName() == slotName
                    end)
                end

                ---@return ScriptConfigMethod[]
                function self.getMethods()
                    return {unpack(methods)}
                end

                return self
            end

            local function createDefaultConfig()
                local config = createConfig()

                for slotIndex = 1, 10 do
                    config.addSlot(slotIndex - 1, "slot" .. slotIndex)
                end

                config.addSlot(-1, "unit", "control")
                config.addSlot(-2, "system", "system")
                config.addSlot(-3, "library", "library")

                return config
            end

            return {
                new = createConfig,
                default = createDefaultConfig
            }

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.ConfigMethod"] = function(...)
            _ENV = _ENV;
            ---@param signature string
            ---@param code string
            local function createConfigMethod(signature, code)
                local self = {} ---@class ScriptConfigMethod

                function self.getSignature()
                    return signature
                end

                function self.getCode()
                    return code
                end

                ---@param newSignature string
                function self.setSignature(newSignature)
                    signature = newSignature
                end

                ---@param newCode string
                function self.setCode(newCode)
                    code = newCode
                end

                return self
            end

            return {
                new = createConfigMethod
            }

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.ConfigSlot"] = function(...)
            _ENV = _ENV;
            local Handler = require "du.script-config.Handler"

            local insert, unpack = table.insert, unpack or table.unpack -- luacheck: ignore unpack
            
            ---@param key number
            ---@param name string
            ---@param elementType string
            local function createConfigSlot(key, name, elementType)
                local self = {} ---@class ScriptConfigSlot

                local handlers = {} ---@type ScriptHandler[]

                function self.getKey()
                    return key
                end

                function self.getName()
                    return name
                end

                function self.getElementType()
                    return elementType
                end

                ---@param newName string
                function self.setName(newName)
                    name = newName
                end

                ---@param newElementType string
                function self.setElementType(newElementType)
                    elementType = newElementType
                end

                ---@param filterSignature string
                ---@param filterArguments string[]
                ---@param code string
                function self.addHandler(filterSignature, filterArguments, code)
                    local handler = Handler.new(filterSignature, filterArguments, code)
                    insert(handlers, handler)
                    return handler
                end

                ---@return ScriptHandler[]
                function self.getHandlers()
                    return {unpack(handlers)}
                end

                return self
            end

            return {
                new = createConfigSlot
            }

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.Handler"] = function(...)
            _ENV = _ENV;
            ---@param filterSignature string
            ---@param filterArguments string[]
            ---@param code string
            local function createHandler(filterSignature, filterArguments, code)
                local self = {} ---@class ScriptHandler

                function self.getFilterSignature()
                    return filterSignature
                end

                function self.getFilterArguments()
                    return filterArguments
                end

                function self.getCode()
                    return code
                end

                ---@param newFilterSignature string
                function self.setFilterSignature(newFilterSignature)
                    filterSignature = newFilterSignature
                end

                ---@param newFilterArguments string
                function self.setFilterArguments(newFilterArguments)
                    filterArguments = newFilterArguments
                end

                ---@param newCode string
                function self.setCode(newCode)
                    code = newCode
                end

                return self
            end

            return {
                new = createHandler
            }

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.autoconfToObject"] =
            function(...)
                _ENV = _ENV;
                local getValueKey = require "common.utils.table.getValueKey"
                local parseFilterSignature = require "du.script-config.parseFilterSignature"
                local OrderedMap = require "common.utils.table.OrderedMap"

                ---@param slot ScriptAutoconfSlot
                local function getSlotObject(slot)
                    local slotObj = OrderedMap {
                        class = slot.getClass()
                    }
                    if slot.getSelect() then
                        slotObj.select = slot.getSelect()
                    end
                    return slotObj
                end

                ---@param slots ScriptAutoconfSlot[]
                local function getSlotsObject(slots)
                    local slotsObj = OrderedMap()

                    for _, slot in ipairs(slots) do
                        if not slot.getIsBuiltin() then
                            slotsObj[slot.getName()] = getSlotObject(slot)
                        end
                    end

                    return slotsObj
                end

                ---@param handler ScriptHandler
                ---@param hasWildcardArgs boolean
                local function getHandlerObject(handler, hasWildcardArgs)
                    local handlerObj = OrderedMap()

                    local filterArguments = handler.getFilterArguments()
                    if #filterArguments > 0 and not hasWildcardArgs then
                        handlerObj.args = filterArguments
                    end

                    handlerObj.lua = handler.getCode()
                    return handlerObj
                end

                ---@param slot ScriptAutoconfSlot
                local function getHandlersObjectForSlot(slot)
                    local handlersObj = OrderedMap()

                    for _, handler in ipairs(slot.getHandlers()) do
                        local filterSignature = handler.getFilterSignature()
                        local hasWildcardArgs = getValueKey(handler.getFilterArguments(), "*")

                        local handlerKey
                        if hasWildcardArgs then
                            handlerKey = filterSignature
                        else
                            local eventName, _ = parseFilterSignature(filterSignature)
                            handlerKey = eventName
                        end

                        handlersObj[handlerKey] = getHandlerObject(handler, hasWildcardArgs)
                    end

                    return handlersObj
                end

                ---@param slots ScriptAutoconfSlot[]
                local function getHandlersObject(slots)
                    local handlersObj = OrderedMap()

                    for _, slot in ipairs(slots) do
                        if #slot.getHandlers() > 0 then
                            handlersObj[slot.getName()] = getHandlersObjectForSlot(slot)
                        end
                    end

                    return handlersObj
                end

                ---@param autoconf ScriptAutoconf
                local function autoconfToObject(autoconf)
                    return OrderedMap {{
                        name = autoconf.getName()
                    }, {
                        slots = getSlotsObject(autoconf.getSlots())
                    }, {
                        handlers = getHandlersObject(autoconf.getSlots())
                    }}
                end

                return autoconfToObject

            end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.autoconfToYaml"] =
            function(...)
                _ENV = _ENV;
                local autoconfToObject = require "du.script-config.autoconfToObject"
                local objectToYaml = require "du.script-config.objectToYaml"

                return function(autoconf)
                    return objectToYaml(autoconfToObject(autoconf))
                end

            end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.configToJson"] = function(...)
            _ENV = _ENV;
            local configToObject = require "du.script-config.configToObject"
            local objectToJson = require "du.script-config.objectToJson"

            return function(config, indent)
                return objectToJson(configToObject(config), indent)
            end

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.configToObject"] =
            function(...)
                _ENV = _ENV;
                local map = require "common.utils.array.map"

                local insert = table.insert

                ---@param slot ScriptConfigSlot
                local function slotToObject(slot)
                    return {
                        name = slot.getName(),
                        type = {
                            methods = {},
                            events = {}
                        },
                        _elementType = slot.getElementType()
                    }
                end

                ---@param argument string
                local function filterArgumentToObject(argument)
                    if argument == "*" then
                        return {
                            variable = argument
                        }
                    else
                        return {
                            value = argument
                        }
                    end
                end

                ---@param handler ScriptHandler
                ---@param handlerKey string
                ---@param slotKey number
                local function handlerToObject(handler, handlerKey, slotKey)
                    return {
                        key = handlerKey,
                        filter = {
                            slotKey = slotKey,
                            signature = handler.getFilterSignature(),
                            args = map(handler.getFilterArguments(), filterArgumentToObject)
                        },
                        code = handler.getCode()
                    }
                end

                ---@param method ScriptConfigMethod
                local function methodToObject(method)
                    return {
                        signature = method.getSignature(),
                        code = method.getCode()
                    }
                end

                ---@param config ScriptConfig
                local function configToObject(config)
                    local obj = {
                        slots = {},
                        handlers = {},
                        methods = {},
                        events = {}
                    }

                    local nextHandlerKey = 0

                    for _, slot in ipairs(config.getSlots()) do
                        obj.slots[tostring(slot.getKey())] = slotToObject(slot)

                        for _, handler in ipairs(slot.getHandlers()) do
                            insert(obj.handlers, handlerToObject(handler, tostring(nextHandlerKey), slot.getKey()))
                            nextHandlerKey = nextHandlerKey + 1
                        end
                    end

                    for _, method in ipairs(config.getMethods()) do
                        insert(obj.methods, methodToObject(method))
                    end

                    return obj
                end

                return configToObject

            end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.objectToJson"] = function(...)
            _ENV = _ENV;
            local json = require "dkjson"

            local insert = table.insert

            local function addNumericKeyOrder(keyorder)
                for key = 0, 200 do
                    insert(keyorder, tostring(key))
                end

                for key = -1, -20, -1 do
                    insert(keyorder, tostring(key))
                end
            end

            local function getJsonOptions(indent)
                local options = {
                    indent = indent,
                    keyorder = {"slots", "handlers", "methods", "events", -- root
                    "name", "type", -- slot
                    "slotKey", "signature", "args", -- handler filter
                    "key", "filter", "code" -- handler
                    }
                }

                addNumericKeyOrder(options.keyorder)

                return options
            end

            return function(obj, indent)
                return json.encode(obj, getJsonOptions(indent))
            end

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.objectToYaml"] = function(...)
            _ENV = _ENV;
            -- Supports just enough of YAML syntax to write an Autoconf file. Won't work with most other objects.

            local concat = table.concat
            local rep = string.rep

            local indent = '  '
            local firstCharsOfQuotedStrings = [['"[]{}>|*&!%#`@,?:-]]

            local function getIndent(indentLevel)
                return rep(indent, indentLevel)
            end

            local function write(buffer, str)
                buffer[#buffer + 1] = str
            end

            local function writeIndent(buffer, indentLevel)
                write(buffer, getIndent(indentLevel))
            end

            local function writeSpace(buffer)
                write(buffer, " ")
            end

            local function writeNewline(buffer)
                write(buffer, "\n")
            end

            local function writeInlineString(buffer, str)
                local firstChar = str:sub(1, 1)
                local shouldQuote = firstCharsOfQuotedStrings:find(firstChar, 1, true)

                if shouldQuote then
                    write(buffer, "'")
                end
                write(buffer, str)
                if shouldQuote then
                    write(buffer, "'")
                end
            end

            local function writeMultilineString(buffer, indentLevel, str)
                writeIndent(buffer, indentLevel)
                write(buffer, str:gsub("\n", "%0" .. getIndent(indentLevel)))
                writeNewline(buffer)
            end

            local function writeInlineArray(buffer, arr)
                write(buffer, "[")

                for index, value in ipairs(arr) do
                    local valueType = type(value)

                    if valueType == "string" and not value:match("\n") then
                        writeInlineString(buffer, value)
                    else
                        error("Array cannot be written. Cannot write element of type " .. valueType .. ".")
                    end

                    if index < #value then
                        write(buffer, ",")
                    end
                end

                write(buffer, "]")
            end

            local function writeTable(buffer, indentLevel, tbl)
                for key, value in pairs(tbl) do
                    writeIndent(buffer, indentLevel)
                    write(buffer, key .. ":")

                    local valueType = type(value)

                    if valueType == "table" then
                        if value[1] then
                            writeSpace(buffer)
                            writeInlineArray(buffer, value)
                            writeNewline(buffer)
                        else
                            writeNewline(buffer)
                            writeTable(buffer, indentLevel + 1, value)
                        end
                    elseif valueType == "string" then
                        if value:match("\n") then
                            write(buffer, " |")
                            writeNewline(buffer)
                            writeMultilineString(buffer, indentLevel + 1, value)
                        else
                            writeSpace(buffer)
                            writeInlineString(buffer, value)
                            writeNewline(buffer)
                        end
                    else
                        error("Table cannot be written. Cannot write value of type " .. valueType .. ".")
                    end
                end
            end

            return function(obj)
                local buffer = {}
                writeTable(buffer, 0, obj)
                return concat(buffer)
            end

        end
    end

    do
        local _ENV = _ENV
        package.preload["du.script-config.parseFilterSignature"] =
            function(...)
                _ENV = _ENV;
                local insert = table.insert

                ---@param filterSignature string
                ---@return string, string[]
                local function parseFilterSignature(filterSignature)
                    local funName, funArgs = filterSignature:match("^([^(]+)%((.*)%)")

                    local argNames = {}
                    for argName in funArgs:gmatch("[^%s,]+") do
                        insert(argNames, argName)
                    end

                    return funName, argNames
                end

                return parseFilterSignature

            end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.fixes"] = function(...)
            _ENV = _ENV;
            return {
                gc = [[
-- Garbage collection fix added by wrap.lua
do
  -- Set GC pause. This more or less means by how many % memory use should increase before a garbage collection is started. Lua default is 200
  local newPause = 110
  local oldPause = collectgarbage("setpause", newPause)

  if oldPause < newPause then
    -- DU now has a different default GC pause which is even lower. Revert back to it.
    collectgarbage("setpause", oldPause)
  end
end
]],
                require = [[
-- require() fix added by wrap.lua
package = package or {}
package.preload = package.preload or {}
package.loaded = package.loaded or {}

package.preload["__wrap_lua__require_test"] = function () return true end

if not require or not pcall(require, "__wrap_lua__require_test") then
  function require (modname)
    if package.loaded[modname] then
      return package.loaded[modname]
    end

    if package.preload[modname] then
      local mod = package.preload[modname]()
      if mod == nil then mod = true end

      package.loaded[modname] = mod
      return mod
    end

    error("module '" .. modname .. "' not found in package.loaded or package.preload")
  end
end
]]
            }

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.getArgsForFilter"] = function(...)
            _ENV = _ENV;
            local map = require "common.utils.array.map"
            local parseFilterSignature = require "du.script-config.parseFilterSignature"

            ---@param filterSignature string
            local function getArgsForFilter(filterSignature)
                local _, argNames = parseFilterSignature(filterSignature)
                return map(argNames, function()
                    return "*"
                end)
            end

            return getArgsForFilter

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.getEventHandlerCode"] = function(...)
            _ENV = _ENV;
            local add = require "common.utils.array.add"
            local getHandlerCode = require "wrap.getHandlerCode"
            local parseFilterSignature = require "du.script-config.parseFilterSignature"

            ---@param templateString string
            ---@param scriptObject string
            ---@param callOperator string
            ---@param slotName string
            ---@param filterSignature string
            local function getEventHandlerCode(templateString, scriptObject, callOperator, slotName, filterSignature)
                local eventName, argNames = parseFilterSignature(filterSignature)
                local eventMethod = "on" .. eventName:gsub("^%l", string.upper)

                local eventArgsWithElement = add(argNames, {slotName})

                return getHandlerCode(templateString, scriptObject, callOperator, eventMethod, eventArgsWithElement)
            end

            return getEventHandlerCode

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.getHandlerCode"] = function(...)
            _ENV = _ENV;
            local replaceVars = require "common.utils.string.replaceVars"

            local concat = table.concat

            ---@param templateString string
            ---@param scriptObject string
            ---@param callOperator string
            ---@param method string
            ---@param args string
            local function getHandlerCode(templateString, scriptObject, callOperator, method, args)
                local argsStr = concat(args, ",")
                local argsStrForPcall = (callOperator == ":" and (scriptObject .. ",") or "") .. argsStr

                return replaceVars(templateString, {
                    scriptObject = scriptObject,
                    callOperator = callOperator,
                    method = method,
                    argsStr = argsStr,
                    argsStrForPcall = argsStrForPcall
                })
            end

            return getHandlerCode

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.getMethodCode"] = function(...)
            _ENV = _ENV;
            local getHandlerCode = require "wrap.getHandlerCode"
            local parseFilterSignature = require "du.script-config.parseFilterSignature"

            ---@param templateString string
            ---@param scriptObject string
            ---@param callOperator string
            ---@param methodSignature string
            local function getEventHandlerCode(templateString, scriptObject, callOperator, methodSignature)
                local methodName, argNames = parseFilterSignature(methodSignature)
                return getHandlerCode(templateString, scriptObject, callOperator, methodName, argNames)
            end

            return getEventHandlerCode

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.getSlotType"] = function(...)
            _ENV = _ENV;
            local slotTypes = require "wrap.slotTypes"

            ---@param requiredSlotTypeName string|nil case-insensitive slot type name
            local function getSlotType(requiredSlotTypeName)
                if not requiredSlotTypeName then
                    return nil
                end

                for slotTypeName, slotType in pairs(slotTypes) do
                    if slotTypeName:lower() == requiredSlotTypeName:lower() then
                        return slotType
                    end
                end

                error("unknown slot type '" .. requiredSlotTypeName .. "'")
            end

            return getSlotType

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.makeAutoconf"] = function(...)
            _ENV = _ENV;
            local assign = require "common.utils.table.assign"
            local getArgsForFilter = require "wrap.getArgsForFilter"
            local getEventHandlerCode = require "wrap.getEventHandlerCode"
            local getSlotType = require "wrap.getSlotType"
            local replaceVars = require "common.utils.string.replaceVars"
            local Autoconf = require "du.script-config.Autoconf"

            local format = string.format

            return function(options)
                local scriptName = options.scriptName
                local startHandlerCode = options.startHandlerCode
                local scriptObjectName = options.scriptObjectName
                local callOperator = options.callOperator
                local slotDefinitions = options.slotDefinitions
                local defaultSlotDefinition = options.defaultSlotDefinition
                local methodSignatures = options.methodSignatures
                local template = options.template

                if defaultSlotDefinition then
                    error("Default slot option cannot be used with YAML output.")
                end

                if #methodSignatures > 0 then
                    error("Methods option cannot be used with YAML output.")
                end

                local autoconf = Autoconf.new(scriptName)

                local fullStartHandlerCode = replaceVars(template.startEventHandler, {
                    scriptObject = scriptObjectName,
                    startHandlerCode = startHandlerCode
                })

                local unitSlot = autoconf.getSlotByName("unit")
                unitSlot.addHandler("start()", {}, fullStartHandlerCode)

                for _, slotDefinition in ipairs(slotDefinitions) do
                    local slotName = slotDefinition.name
                    local slotTypeName = slotDefinition.type
                    local slotSelect = slotDefinition.select

                    local slotType = getSlotType(slotTypeName) or {}

                    if slotDefinition.class then
                        slotType = assign({}, slotType, {
                            class = slotDefinition.class
                        })
                    end

                    local slotClass = slotType.class or
                                          error(format("Slot type '%s' cannot be used with YAML output.", slotTypeName))

                    autoconf.addSlot(slotName, slotTypeName, slotClass, slotSelect)
                end

                for _, slot in ipairs(autoconf.getSlots()) do
                    local slotName = slot.getName()
                    local slotType = getSlotType(slot.getTypeName())

                    for _, filterSignature in ipairs(slotType and slotType.filters or {}) do
                        local filterArgs = getArgsForFilter(filterSignature)
                        local handlerCode = getEventHandlerCode(template.eventHandler, scriptObjectName, callOperator,
                                                slotName, filterSignature)

                        slot.addHandler(filterSignature, filterArgs, handlerCode)
                    end
                end

                return autoconf
            end

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.makeConfig"] = function(...)
            _ENV = _ENV;
            local getArgsForFilter = require "wrap.getArgsForFilter"
            local getEventHandlerCode = require "wrap.getEventHandlerCode"
            local getMethodCode = require "wrap.getMethodCode"
            local getSlotType = require "wrap.getSlotType"
            local replaceVars = require "common.utils.string.replaceVars"
            local Config = require "du.script-config.Config"

            return function(options)
                local startHandlerCode = options.startHandlerCode
                local scriptObjectName = options.scriptObjectName
                local callOperator = options.callOperator
                local slotDefinitions = options.slotDefinitions
                local defaultSlotDefinition = options.defaultSlotDefinition
                local methodSignatures = options.methodSignatures
                local template = options.template

                local config = Config.default()

                local fullStartHandlerCode = replaceVars(template.startEventHandler, {
                    scriptObject = scriptObjectName,
                    startHandlerCode = startHandlerCode
                })

                local unitSlot = config.getSlotByName("unit")
                unitSlot.addHandler("start()", {}, fullStartHandlerCode)

                for slotIndex, slotDefinition in ipairs(slotDefinitions) do
                    if slotDefinition.class then
                        error("Slot option key 'class' cannot be used with JSON output.")
                    end
                    if slotDefinition.select then
                        error("Slot option key 'select' cannot be used with JSON output.")
                    end

                    local slotName = slotDefinition.name
                    local slotTypeName = slotDefinition.type

                    local slot = config.getSlotByKey(slotIndex - 1)
                    slot.setName(slotName)

                    if slotTypeName then
                        slot.setElementType(slotTypeName)
                    end
                end

                for _, slot in ipairs(config.getSlots()) do
                    local slotName = slot.getName()
                    local slotTypeName = slot.getElementType() or defaultSlotDefinition and defaultSlotDefinition.type

                    local slotType = getSlotType(slotTypeName)
                    local filterSignatures = slotType and slotType.filters or {}

                    for _, filterSignature in ipairs(filterSignatures) do
                        local filterArgs = getArgsForFilter(filterSignature)
                        local handlerCode = getEventHandlerCode(template.eventHandler, scriptObjectName, callOperator,
                                                slotName, filterSignature)

                        slot.addHandler(filterSignature, filterArgs, handlerCode)
                    end
                end

                for _, methodSignature in ipairs(methodSignatures) do
                    local methodCode = getMethodCode(template.methodHandler, scriptObjectName, callOperator,
                                           methodSignature)
                    config.addMethod(methodSignature, methodCode)
                end

                return config
            end

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.slotTypes"] = function(...)
            _ENV = _ENV;
            local add = require "common.utils.array.add"

            local types = {
                -- elements
                antigravityGenerator = {
                    class = "AntiGravityGeneratorUnit"
                },
                core = {
                    class = "CoreUnit"
                },
                databank = {
                    class = "DataBank"
                },
                fuelContainer = {
                    class = "FuelContainer"
                },
                industry = {
                    class = "IndustryUnit",
                    filters = {"completed()", "statusChanged(status)"}
                },
                gyro = {
                    class = "GyroUnit"
                },
                radar = {
                    class = "RadarUnit"
                },
                pvpRadar = {
                    class = "RadarPVPUnit"
                },
                screen = {
                    class = "ScreenUnit",
                    filters = {"mouseDown(x,y)", "mouseUp(x,y)"}
                },
                laserDetector = {
                    class = "LaserDetectorUnit",
                    filters = {"laserHit()", "laserRelease()"}
                },
                receiver = {
                    class = "ReceiverUnit",
                    filters = {"receive(channel,message)"}
                },
                warpDrive = {
                    class = "WarpDriveUnit"
                },
                weapon = {
                    class = "WeaponUnit"
                },

                -- abstract
                enterable = {
                    filters = {"enter(id)", "leave(id)"}
                },
                pressable = {
                    filters = {"pressed()", "released()"}
                },

                -- built-in
                control = {
                    filters = {"stop()", "tick(timerId)"}
                },
                system = {
                    filters = {"actionStart(action)", "actionStop(action)", "actionLoop(action)", "update()", "flush()", "inputText(text)"}
                },
                library = {}
            }

            types.anything = {
                filters = add(types.enterable.filters, types.industry.filters, types.pressable.filters,
                    types.laserDetector.filters, types.receiver.filters, types.screen.filters)
            }

            types.pvpRadar.filters = types.enterable.filters
            types.radar.filters = types.enterable.filters

            return types

        end
    end

    do
        local _ENV = _ENV
        package.preload["wrap.templates"] = function(...)
            _ENV = _ENV;
            return {
                copy = function(template)
                    return {
                        eventHandler = template.eventHandler,
                        methodHandler = template.methodHandler,
                        startEventHandler = template.startEventHandler
                    }
                end,

                default = {
                    eventHandler = "if {scriptObject}.{method} then {scriptObject}{callOperator}{method}({argsStr}) end",
                    methodHandler = "if {scriptObject}.{method} then return {scriptObject}{callOperator}{method}({argsStr}) end",
                    startEventHandler = "{startHandlerCode}"
                },
                withErrorHandling = {
                    eventHandler = [[
if not __wrap_lua__stopped and {scriptObject}.{method} then
  local ok, message = xpcall({scriptObject}.{method},__wrap_lua__traceback,{argsStrForPcall})
  if not ok then __wrap_lua__error(message) end
end]],
                    methodHandler = [[
if {scriptObject}.{method} then
  local ret = { xpcall({scriptObject}.{method},__wrap_lua__traceback,{argsStrForPcall}) }
  if not ret[1] then __wrap_lua__error(ret[2]) end
  return table.unpack(ret, 2)
end]],
                    startEventHandler = [=[
-- error handling code added by wrap.lua
__wrap_lua__stopped = false
__wrap_lua__stopOnError = false
__wrap_lua__rethrowErrorAlways = false
__wrap_lua__rethrowErrorIfStopped = true
__wrap_lua__printError = true
__wrap_lua__showErrorOnScreens = true

function __wrap_lua__error (message)
  if __wrap_lua__stopped then return end

  -- make the traceback more readable and escape HTML syntax characters
  message = tostring(message):gsub('"%-%- |STDERROR%-EVENTHANDLER[^"]*"', 'chunk'):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

  local unit = unit or self or {}

  if __wrap_lua__showErrorOnScreens then
    for _, value in pairs(unit) do
      if type(value) == "table" and value.setCenteredText and value.setHTML then -- value is a screen
        if message:match("\n") then
          value.setHTML([[
<pre style="color: white; background-color: black; font-family: Consolas,monospace; font-size: 4vh; white-space: pre-wrap; margin: 1em">
Error: ]] .. message .. [[
</pre>]])
        else
          value.setCenteredText(message)
        end
      end
    end
  end

  if __wrap_lua__printError and system and system.print then
    system.print("Error: " .. message:gsub("\n", "<br>"))
  end

  if __wrap_lua__stopOnError then
    __wrap_lua__stopped = true
  end

  if __wrap_lua__stopped and unit and unit.exit then
    unit.exit()
  end

  if __wrap_lua__rethrowErrorAlways or (__wrap_lua__stopped and __wrap_lua__rethrowErrorIfStopped) then
    error(message)
  end
end

-- in case traceback is removed or renamed
__wrap_lua__traceback = traceback or (debug and debug.traceback) or function (arg1, arg2) return arg2 or arg1 end

local ok, message = xpcall(function ()

-- script code

{startHandlerCode}

-- error handling code added by wrap.lua
end, __wrap_lua__traceback)
if not ok then
  __wrap_lua__error(message)
  if not {scriptObject} then {scriptObject} = {} end
end]=]
                },
                withErrorHandlingMinified = {
                    eventHandler = [[
if not __wrap_lua__stopped and {scriptObject}.{method} then
local a,b=xpcall({scriptObject}.{method},__wrap_lua__traceback,{argsStrForPcall})
if not a then __wrap_lua__error(b) end
end]],
                    methodHandler = [[
if {scriptObject}.{method} then
local a={xpcall({scriptObject}.{method},__wrap_lua__traceback,{argsStrForPcall})}
if not a[1] then __wrap_lua__error(a[2]) end
return table.unpack(a, 2)
end]],
                    startEventHandler = [=[
__wrap_lua__stopped=false
__wrap_lua__stopOnError=false
__wrap_lua__rethrowErrorAlways=false
__wrap_lua__rethrowErrorIfStopped=true
__wrap_lua__printError=true
__wrap_lua__showErrorOnScreens=true
function __wrap_lua__error(a)
if __wrap_lua__stopped then return end
a=tostring(a):gsub('"%-%- |STDERROR%-EVENTHANDLER[^"]*"','chunk'):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
local b=unit or self or {}
if __wrap_lua__showErrorOnScreens then for _,c in pairs(b) do if type(c)=="table" and c.setCenteredText and c.setHTML then if a:match("\n") then c.setHTML([[
<pre style="color: white; background-color: black; font-family: Consolas,monospace; font-size: 4vh; white-space: pre-wrap; margin: 1em">
Error: ]]..a..[[
</pre>]]) else c.setCenteredText(a) end end end end
if __wrap_lua__printError and system and system.print then system.print("Error: "..a:gsub("\n","<br>")) end
if __wrap_lua__stopOnError then __wrap_lua__stopped=true end
if __wrap_lua__stopped and b and b.exit then b.exit() end
if __wrap_lua__rethrowErrorAlways or (__wrap_lua__stopped and __wrap_lua__rethrowErrorIfStopped) then error(a) end
end
__wrap_lua__traceback=traceback or (debug and debug.traceback) or function(a,b)return b or a end
local a,b=xpcall(function()
{startHandlerCode}
end,__wrap_lua__traceback)
if not a then
__wrap_lua__error(b)
if not {scriptObject} then {scriptObject} = {} end
end
]=]
                }
            }

        end
    end

end

-- Lua script packager/configurator for DU
-- Copyright (C) 2020 D. L., a.k.a hdparm

require "common.utils.compat.pairs"

local argparse = require "argparse"
local fixes = require "wrap.fixes"
local getKeys = require "common.utils.table.getKeys"
local getValueKey = require "common.utils.table.getValueKey"
local makeAutoconf = require "wrap.makeAutoconf"
local makeConfig = require "wrap.makeConfig"
local map = require "common.utils.array.map"
local autoconfToYaml = require "du.script-config.autoconfToYaml"
local configToJson = require "du.script-config.configToJson"
local templates = require "wrap.templates"

local format = string.format
local concat, sort = table.concat, table.sort

local function listSlotTypes()
    local slotTypes = require "wrap.slotTypes"

    local slotTypeNames = getKeys(slotTypes)
    sort(slotTypeNames)

    print("Slot types:")

    for _, slotTypeName in ipairs(slotTypeNames) do
        local filterSignatures = slotTypes[slotTypeName].filters or {}

        if #filterSignatures > 0 then
            local quotedFilterSignatures = map(filterSignatures, function(filterSignature)
                return format("%q", filterSignature)
            end)
            print(format("* Slot type %q adds event handlers for %s.", slotTypeName,
                      concat(quotedFilterSignatures, ", ")))
        else
            print(format("* Slot type %q adds no event handlers.", slotTypeName))
        end
    end

    os.exit(0)
end

local function checkOutputType(value)
    if not value then
        return "json"
    end

    if value ~= "json" and value ~= "yaml" then
        error(format('Invalid output type "%s". Must be "json" or "yaml".'), value)
    end

    return value
end

local function parseSlotOptions(options, slot)
    slot = slot or {}

    local validKeys = {"class", "select", "type"}
    local function isKeyValid(key)
        return getValueKey(validKeys, key)
    end

    local function addToSlot(key, value)
        if not isKeyValid(key) then
            error(format('Invalid key "%s" in slot options.', key))
        end

        slot[key] = value
    end

    repeat
        local prevOptions = options
        options = options:gsub(",([^=,]+)=([^=]*)$", function(...)
            addToSlot(...)
            return ""
        end)
    until prevOptions == options

    local lastKey, lastValue = options:match("^([^=]+)=(.*)$")
    if not lastKey then
        error('Slot options must look like "key1=value1,key2=value".')
    else
        addToSlot(lastKey, lastValue)
    end

    return slot
end

local function parseSlot(slotDef)
    slotDef = tostring(slotDef)

    local name, options = slotDef:match("^([^:]+):?(.*)$")
    if not name:match("^[_%a][_%w]*$") then
        error(format('Invalid slot name "%s".', name))
    end

    local slot = {
        name = name
    }

    if #options > 0 then
        parseSlotOptions(options, slot)
    end

    return slot
end

local function getArgs()
    local parser = argparse(arg[0], [[
This script generates a DU-compatible script configuration from a single .lua file.

To use this script, structure your code like this:
  script = {}

  function script.onActionStart (actionName)
    -- handle the actionStart event:
    screen.setCenteredText("action start: " ..  actionName)
  end

  function script.onActionStop (actionName)
    -- handle the actionStop event:
    screen.setCenteredText("action stop: " ..  actionName)
  end

  function script.onStop()
    -- handle the unit stop event:
    screen.setCenteredText("goodbye")
  end

This code will be placed inside the unit start handler. All other event handlers will be generated automatically and will call methods of the script object.]])

    parser:argument("input file", "The Lua file that contains script code."):target "inputFile":convert(io.open)
    parser:argument("output file",
        "The file that the JSON configuration or the YAML autoconf will be written to. If not set, standard output will be used instead.")
        :args "?":target "outputFile":convert(function(fileName)
            return io.open(fileName, "w")
        end)
    parser:option("--output", [[
Output format. Valid values: "json", "yaml". Defaults to "json".
JSON output can be pasted in-game by right-clicking on the control unit.
YAML files the with .conf extension can be placed in data/lua/autoconf/custom.]]):argname "<format>":convert(
        checkOutputType)
    parser:option("--name", "Script name. Only used when outputting YAML."):convert(tostring)
    parser:option("--slots", [[
Control unit slot names and, optionally, element types (to generate element type specific event handlers).
When output format is YAML, "class" option can be used to link elements that do not have a type defined in this script, and the "select=all" option can be used to link all elements of that type or class.
Unit, system and library slots are added automatically. Slot names default to slot1, slot2, ..., slot10.]]):args "0-50"
        :argname "<slot_name>[:type=<slot_type>[,class=<slot_class>][,select=all]]":convert(parseSlot)
    parser:option("--methods", [[
Methods to define on the control unit. This is not very useful and is only supported when outputting JSON.]]):args "*"
        :argname "<method_signature>":target "methodSignatures"
    parser:option("--object", "The name of the object containing the event handlers. Defaults to \"script\".")
        :argname "<script_object_name>":convert(tostring)
    parser:option("--call-with", "Event handler function call operator. Valid values: \".\", \":\". Defaults to \".\".")
        :argname "<dot_or_colon>":target "callOperator"
    parser:option("--default-slot", "Default slot options."):argname "type=<slot_type>":target "defaultSlot":convert(
        parseSlotOptions)
    parser:flag("--fix-gc", [[
Adjust GC to run more frequently. This can help prevent memory overload errors.]]):target "fixGC"
    parser:flag("--fix-require", [[
Replace non-working require() with a function that looks in package.preload and package.loaded.
This is not necessary unless require() is disabled in-game again.]]):target "fixRequire"
    parser:mutex(parser:flag("--handle-errors", "Add error handling code that displays errors on screen elements.")
                     :target "handleErrors",
        parser:flag("--handle-errors-min", "Add minified error handling code that displays errors on screen elements.")
            :target "handleErrorsMin")
    parser:flag("--indent-json", "Indent the JSON output."):target "indent"
    parser:flag("--list-slot-types", "Lists slot types supported by the --slots option."):action(listSlotTypes)

    return parser:parse()
end

local args = getArgs()

local startHandlerCode = args.inputFile:read("*all")
args.inputFile:close()

local template
if args.handleErrors then
    template = templates.withErrorHandling
elseif args.handleErrorsMin then
    template = templates.withErrorHandlingMinified
else
    template = templates.default
end
template = templates.copy(template)

if args.fixGC then
    template.startEventHandler = fixes.gc .. template.startEventHandler
end
if args.fixRequire then
    template.startEventHandler = fixes.require .. template.startEventHandler
end

local options = {
    scriptName = args.name,
    startHandlerCode = startHandlerCode,
    scriptObjectName = args.object or "script",
    callOperator = args.callOperator or ".",
    slotDefinitions = args.slots or {},
    defaultSlotDefinition = args.defaultSlot or nil,
    methodSignatures = args.methodSignatures or {},
    template = template
}

local wrappedCode
if args.output == "yaml" then
    if args.indent then
        error("--indent-json flag cannot be used with YAML output.")
    end

    local autoconf = makeAutoconf(options)
    wrappedCode = autoconfToYaml(autoconf)
else
    local config = makeConfig(options)
    wrappedCode = configToJson(config, args.indent)
end

if args.outputFile then
    args.outputFile:write(wrappedCode)
    args.outputFile:close()
else
    io.write(wrappedCode)
end
--------------------------------------------------------------------------------
-- wrap.lua bundle ends
--------------------------------------------------------------------------------
