#pragma mark scalar min/max

#define TBMin(aValue1, aValue2) (((aValue1) < (aValue2)) ? (aValue1) : (aValue2))
#define TBMax(aValue1, aValue2) (((aValue1) > (aValue2)) ? (aValue1) : (aValue2))


#pragma mark conversion between radians/degrees

#define TBDegreesToRadians(aDegrees) ((aDegrees) * M_PI / 180)
#define TBRadiansToDegrees(aRadians) ((aRadians) * 180 / M_PI)
