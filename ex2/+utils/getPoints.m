function [ fixedPoints, movingPoints ] = getPart1Points( str )

movingPoints =[...
  345.7500  416.7500
  106.2500  334.2500
  414.2500  163.7500
  256.7500  458.2500
  366.7500  320.2500
  263.2500  306.2500
  198.7500  122.7500
  372.7500  187.7500
  425.7500  369.7500];


fixedPoints =[...
  247.7500  440.2500
   88.2500  243.2500
  439.7500  256.2500
  150.2500  426.7500
  316.2500  370.2500
  236.2500  303.2500
  279.2500  112.7500
  392.7500  261.2500
  341.7500  442.2500];

if (strcmp(str,'no_outliers'))
elseif (strcmp(str,'with_outliers'))
	movingPoints = [movingPoints;
      211.7500  393.2500
      119.2500  164.2500
      298.2500  110.7500];
	fixedPoints = [fixedPoints;
      119.7500  271.7500
      158.7500  137.2500
      361.7500  145.7500];
	
else
	error(['unknown string ' str]);
end
end

