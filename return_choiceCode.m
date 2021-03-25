function choice = return_choiceCode(s,a)

if     s == 1 && a == 1
    choice = 1;
    
elseif s == 2 && a == 1
    choice = 2;
    
elseif s == 1 && a == 2
    choice = 3;
    
elseif s == 2 && a == 2
    choice = 4;
end