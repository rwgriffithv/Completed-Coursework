#ifndef PROVIDED_INCLUDED
#define PROVIDED_INCLUDED

#include <string>
#include <vector>

struct GeoCoord
{
	GeoCoord(std::string lat, std::string lon)
     : latitudeText(lat), longitudeText(lon), latitude(std::stod(lat)), longitude(std::stod(lon))
	{}

	GeoCoord()
	 : latitudeText("0"), longitudeText("0"), latitude(0), longitude(0)
	{}

	std::string latitudeText;
	std::string longitudeText;
	double      latitude;
	double      longitude;
};

struct GeoSegment
{
	GeoSegment(const GeoCoord& s, const GeoCoord& e)
		: start(s), end(e)
	{}

	GeoSegment()
	{}

	GeoCoord start;
	GeoCoord end;
};

struct Attraction
{
	std::string name;
	GeoCoord	geocoordinates;
};

struct StreetSegment
{
	std::string				streetName;
	GeoSegment				segment;
	std::vector<Attraction>	attractions;
};

class MapLoaderImpl;

class MapLoader
{
public:
    MapLoader();
    ~MapLoader();
    bool load(std::string mapFile);
    size_t getNumSegments() const;
    bool getSegment(size_t segNum, StreetSegment& seg) const;
      // We prevent a MapLoader object from being copied or assigned.
    MapLoader(const MapLoader&) = delete;
    MapLoader& operator=(const MapLoader&) = delete;
private:
    MapLoaderImpl* m_impl;
};

class AttractionMapperImpl;

class AttractionMapper
{
public:
    AttractionMapper();
    ~AttractionMapper();
    void init(const MapLoader& ml);
    bool getGeoCoord(std::string attraction, GeoCoord& gc) const;
      // We prevent an AttractionMapper object from being copied or assigned.
    AttractionMapper(const AttractionMapper&) = delete;
    AttractionMapper& operator=(const AttractionMapper&) = delete;
private:
    AttractionMapperImpl* m_impl;
};

class SegmentMapperImpl;

class SegmentMapper
{
public:
    SegmentMapper();
    ~SegmentMapper();
    void init(const MapLoader& ml);
    std::vector<StreetSegment> getSegments(const GeoCoord& gc) const;
      // We prevent a SegmentMapper object from being copied or assigned.
    SegmentMapper(const SegmentMapper&) = delete;
    SegmentMapper& operator=(const SegmentMapper&) = delete;
private:
    SegmentMapperImpl* m_impl;
};

struct NavSegment
{
public:
	enum NavCommand { PROCEED, TURN };

	NavSegment()
     : m_command(PROCEED), m_distance(0)
	{}
	
      // constructor for a Proceed NavSegment
	NavSegment(std::string direction, std::string streetName, double distance, const GeoSegment& gs)
     : m_command(PROCEED), m_direction(direction), m_streetName(streetName), m_distance(distance), m_geoSegment(gs)
	{}
	
      // constructor for a Turn NavSegment
	NavSegment(std::string direction, std::string streetName)
     : m_command(TURN), m_direction(direction), m_streetName(streetName)
	{}

	NavCommand	m_command;	    // PROCEED or TURN
	std::string	m_direction;	// e.g., "north" for proceed or "left" for turn
	std::string	m_streetName;	// e.g., Westwood Blvd
	double		m_distance;		// for proceed, distance in miles
	GeoSegment	m_geoSegment;
};

enum NavResult {
	NAV_SUCCESS, NAV_BAD_SOURCE, NAV_BAD_DESTINATION, NAV_NO_ROUTE
};

class NavigatorImpl;

class Navigator
{
public:
    Navigator();
    ~Navigator();
    bool loadMapData(std::string mapFile);
    NavResult navigate(std::string start, std::string end, std::vector<NavSegment>& directions) const;
      // We prevent a Navigator object from being copied or assigned.
    Navigator(const Navigator&) = delete;
    Navigator& operator=(const Navigator&) = delete;
private:
    NavigatorImpl* m_impl;
};

// Tools for computing distance between GeoCoords, angle of a GeoSegment,
// and angle between two GeoSegments 

#include <cmath> 

  // decimal degrees to radians
inline double deg2rad(double deg) {
	static const double PI = 4 * std::atan(1.0);
	return deg * PI / 180;
}

  // radians to decimal degrees
inline double rad2deg(double rad) {
	static const double PI = 4 * std::atan(1.0);
	return rad * 180 / PI;
}

/**
* Returns the distance between two points on the Earth.
* Direct translation from http://en.wikipedia.org/wiki/Haversine_formula
* @param lat1d Latitude of the first point in degrees
* @param lon1d Longitude of the first point in degrees
* @param lat2d Latitude of the second point in degrees
* @param lon2d Longitude of the second point in degrees
* @return The distance between the two points in kilometers
*/
inline double distanceEarthKM(const GeoCoord& g1, const GeoCoord& g2) {
	static const double earthRadiusKm = 6371.0;
	double lat1r = deg2rad(g1.latitude);
	double lon1r = deg2rad(g1.longitude);
	double lat2r = deg2rad(g2.latitude);
	double lon2r = deg2rad(g2.longitude);
	double u = std::sin((lat2r - lat1r) / 2);
	double v = std::sin((lon2r - lon1r) / 2);
	return 2.0 * earthRadiusKm * std::asin(std::sqrt(u * u + std::cos(lat1r) * std::cos(lat2r) * v * v));
}

inline double distanceEarthMiles(const GeoCoord& g1, const GeoCoord& g2) {
	const double milesPerKm = 0.621371;
	return distanceEarthKM(g1, g2) * milesPerKm;
}

inline double angleBetween2Lines(const GeoSegment& line1, const GeoSegment& line2)
{
	double angle1 = atan2(line1.end.latitude - line1.start.latitude, line1.end.longitude - line1.start.longitude);
	double angle2 = atan2(line2.end.latitude - line2.start.latitude, line2.end.longitude - line2.start.longitude);

	double result = rad2deg(angle2 - angle1);
	if (result < 0)
		result += 360;

	return result;
}

inline double angleOfLine(const GeoSegment& line1)
{
	double angle = atan2(line1.end.latitude - line1.start.latitude, line1.end.longitude - line1.start.longitude);
	double result = rad2deg(angle);
	if (result < 0)
		result += 360;

	return result;
}

#endif // PROVIDED_INCLUDED
