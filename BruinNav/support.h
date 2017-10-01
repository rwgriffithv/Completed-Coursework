#ifndef SUPPORT_INCLUDED
#define SUPPORT_INCLUDED
#include "provided.h"
#include <cstdlib>
#include <string>
#include <list>

//turn string of two coordinates into geosegment
GeoSegment stringToSegment(const std::string& s);

//turn string with attraction name and coordinate into an attraction object
Attraction stringToAttraction(const std::string& s);

//GeoCoord operators
bool operator <(const GeoCoord& left, const GeoCoord& right);
bool operator >(const GeoCoord& left, const GeoCoord& right);
bool operator ==(const GeoCoord& left, const GeoCoord& right);
bool operator !=(const GeoCoord& left, const GeoCoord& right);

//string modifier to aide in search of attractions
std::string toLower(const std::string& s);

//StreetSegment operators
bool operator ==(const StreetSegment& left, const StreetSegment& right);
bool operator !=(const StreetSegment& left, const StreetSegment& right);

//Navigator.cpp helper functions for constructing directions
std::string coordsToDirection(const GeoCoord& start, const GeoCoord& end);
std::string coordsToTurnDirection(const GeoCoord& start, const GeoCoord& middle, const GeoCoord& end);
std::string directionOfLine(const GeoSegment& gs);	
//directionOfLine would have not needed it, but it's necessary for the given main function 
//my algorithm and code was designed around points, not lines, so this would have been unnecesary
std::string findCommonStreetName(const std::vector<StreetSegment> &s1, const std::vector<StreetSegment> &s2);

#endif
