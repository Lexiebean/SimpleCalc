local string_gfind = string.gmatch or string.gfind

-- Initialise SimpleCalc
function SimpleCalc_OnLoad(self)

  -- Register our slash commands
  SLASH_SIMPLECALC1="/simplecalc";
  SLASH_SIMPLECALC2="/calc";
  SlashCmdList["SIMPLECALC"]=SimpleCalc_ParseParameters;

  -- Let the user know that we're here
  DEFAULT_CHAT_FRAME:AddMessage("[+] SimpleCalc initiated! Type: /calc for help.", 1, 1, 1);

end


-- Parse any user-passed parameters
function SimpleCalc_ParseParameters(paramStr)

  local params={};

  paramStr=string.lower(paramStr);

  local i=0;
  local a=nil;
  local b=nil;
  local result=0;
  local paramCount=0;
  for param in string_gfind(paramStr, "[^%s]+") do

    i=i+1;
    paramCount=paramCount+1;

    -- Make sure that we've been passed a number
    if (i==1 or i==3) then
      if (string.find(param, '[^%d\.-]')) then
        SimpleCalc_Error(paramStr .. ': \'' .. param .. '\' doesn\'t look like a number to me!');
        return false;
      end
    end

    if (i==1) then
      a=tonumber(param);
    elseif (i==2) then
      operator=param;
    elseif (i==3) then
      b=tonumber(param);

      -- Perform the operation
      -- Can't find any way around doing things this way...
      if (operator=='+') then
        result=a + b;
      elseif (operator=='-') then
        result=a - b;
      elseif (operator=='*') then
        result=a * b;
      elseif (operator=='/') then
        result=a / b;
      elseif (operator=='^') then
        result=a ^ b;
      else
        SimpleCalc_Error('Unrecognised operator: ' .. operator);
        if (operator=='x') then
          SimpleCalc_Error('Perhaps you meant '*' (multiply)?');
        end
        return false;
      end

      -- Reset for another loop
      i=1;
      operator=nil;
      a=result;
      b=nil;

    end

  end

  if (operator and not b) then
    SimpleCalc_Error('Unbalanced parameter count. Trailing operator: ' .. operator .. '?');
  end

  if (paramCount >= 3) then
    SimpleCalc_Message(paramStr .. ' = ' .. number_format(result));
  else
    SimpleCalc_Usage();
  end

end


-- Inform the user of our their options
  SimpleCalc_Message("SimpleCalc - Simple mathematical calculator - https://github.com/Lexiebean/SimpleCalc");
function SimpleCalc_Usage()
  SimpleCalc_Message("Usage: /calc <value> <operator> <value> ...");
  SimpleCalc_Message("Example: /calc 1000 - 100 * 3");
  SimpleCalc_Message("value - A numeric value");
  SimpleCalc_Message("operator - A mathematical operator (supported operators: +, -, /, *, ^)");
end


-- Output errors
function SimpleCalc_Error(message)
  DEFAULT_CHAT_FRAME:AddMessage("[SimpleCalc] " .. message, 0.8, 0.2, 0.2);
end


-- Output messages
function SimpleCalc_Message(message)
  DEFAULT_CHAT_FRAME:AddMessage("[SimpleCalc] " .. message, 0.4, 0.4, 1);
end


-- Number formatting function, taken from http://lua-users.org/wiki/FormattingNumbers
function number_format(amount)
  local formatted = amount;
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2');
    if (k==0) then
      break;
    end
  end
  return formatted;
end

