function accuracy = return_correctness(choiceCode)
%-only in the learning phase
if choiceCode == 1 || choiceCode == 2
    accuracy = 1;
else
    accuracy = 0;
end