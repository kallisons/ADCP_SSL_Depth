
function c = cstyle(j)
   n = mod(j,15);
   switch n
     case 0
      c = '-oc';
     case 1
      c = '-c';
     case 2
      c = '-r';
     case 3
      c = '-b';
     case 4
      c = '-k';
     case 5
      c = '-m';
     case 6
      c = '-g';
     case 7
      c = '--g';
     case 8
      c = '-or';
     case 9
      c = '-ob';
     case 10
      c = '-og';
     case 11
      c = '-om';
     case 12
      c = '-.c';
     case 13
      c = ':k';
     case 14
      c = ':r';
     case 15
      c = ':b';
   end
 end

