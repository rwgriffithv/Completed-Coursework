#include "support.h"
#include "provided.h"
#include <iostream>
#include <string>
#include <cctype>

GeoSegment stringToSegment(const std::string& s)
{
	int coordCount = 0;
	std::string coord[4];
	for (int k = 0; k < s.size(); k++)
	{
		if (isdigit(s[k]) || s[k] == '.' || s[k] == '-')
			coord[coordCount] += s[k];
		if ((s[k] == ',' || s[k] == ' ') && k > 0 && isdigit(s[k-1]))
			coordCount++;
	}
	for (int k = 0; k < 4; k++)
		if (coord[k] == "")
			std::cerr << s << std::endl;

	GeoCoord gCoord1(coord[0], coord[1]);
	GeoCoord gCoord2(coord[2], coord[3]);
	GeoSegment segment(gCoord1, gCoord2);
	return segment;
}

Attraction stringToAttraction(const std::string& s)
{
	std::string coord[2];
	std::string name;
	int coordCount = 0;
	bool atName = true;
	for (int j = 0; j < s.size(); j++)
	{
		if (s[j] == '|')
			atName = false;
		if (atName)
			name += s[j];
		else
		{
			if (isdigit(s[j]) || s[j] == '.' || s[j] == '-')
				coord[coordCount] += s[j];
			if (s[j] == ',' || s[j] == ' ' && j > 0 && isdigit(s[j - 1]))
				coordCount++;
		}
	}

	Attraction a;
	GeoCoord g(coord[0], coord[1]);
	a.geocoordinates = g;
	a.name = name;
	return a;
}

bool operator <(const GeoCoord& left, const GeoCoord& right)
{
	return (left.latitude + left.longitude < right.latitude + right.longitude);
}

bool operator >(const GeoCoord& left, const GeoCoord& right)
{
	return (left.latitude + left.longitude > right.latitude + right.longitude);
}

bool operator ==(const GeoCoord& left, const GeoCoord& right)
{
	return (left.latitude == right.latitude && left.longitude == right.longitude);
}

bool operator !=(const GeoCoord& left, const GeoCoord& right)
{
	return !(left.latitudeText == right.latitudeText && left.longitudeText == right.longitudeText);

}

std::string toLower(const std::string& s)
{
	std::string lower = "";
	for (int k = 0; k < s.size(); k++)
	{
		lower += tolower(s[k]);
	}
	return lower;
}

bool operator ==(const StreetSegment& left, const StreetSegment& right)
{
	return (left.segment.start == right.segment.start && left.segment.end == right.segment.end);
}

bool operator !=(const StreetSegment& left, const StreetSegment& right)
{
	return !(left == right);

}
std::string coordsToDirection(const GeoCoord& start, const GeoCoord& end)
{
	GeoSegment g(start, end);
	double x = angleOfLine(g);
	if (x >= 0 && x <= 22.5)
		return "east";
	if (x > 22.5 && x <= 67.5)
		return "northeast";
	if (x > 67.5 && x <= 112.5)
		return "north";
	if (x > 112.5 && x <= 157.5)
		return "northwest";
	if (x > 157.5 && x <= 202.5)
		return "west";
	if (x > 202.5 && x <= 247.5)
		return "southwest";
	if (x > 247.5 && x <= 292.5)
		return "south";
	if (x > 292.5 && x <= 337.5)
		return "southeast";
	if (x > 337.5 && x <= 360)
		return "east";
	return "";
}

std::string coordsToTurnDirection(const GeoCoord& start, const GeoCoord& middle, const GeoCoord& end)
{
	GeoSegment g1(start, middle);
	GeoSegment g2(middle, end);
	double x = angleBetween2Lines(g1, g2);

	if (x < 180)
		return "left";
	if (x > 180)
		return "right";
	return "";
}

std::string directionOfLine(const GeoSegment& gs)
{
	return coordsToDirection(gs.start, gs.end);
}

std::string findCommonStreetName(const std::vector<StreetSegment> &s1, const std::vector<StreetSegment> &s2) 
{
	for (int k = 0; k < s1.size(); k++)
		for (int j = 0; j < s2.size(); j++)
			if (s1[k] == s2[j])
				return s1[k].streetName;
	return "";
}