function flag = iszero(a)

flag = 1;

n = length(a);
for i = 1:n
    if a(i) ~= 0 
        flag = 0;
        break;
    end
end