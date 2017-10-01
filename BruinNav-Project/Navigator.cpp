#include "provided.h"
#include "support.h"
#include "MyMap.h"
#include <string>
#include <vector>
#include <queue>
#include <list>
using namespace std;

class NavigatorImpl
{
public:
    NavigatorImpl();
    ~NavigatorImpl();
    bool loadMapData(string mapFile);
    NavResult navigate(string start, string end, vector<NavSegment>& directions) const;
private:
	struct NavHelper	//made for use in a priority_queue
	{
		NavHelper(GeoCoord coord, GeoCoord end, NavHelper* previous, double oDistance) :n_gCoord(coord)
		{
			n_prev = previous;
			if (previous == nullptr)
			{
				n_pathDistance = 0;
				n_priority = 0;
			}
			else
			{
				n_pathDistance = previous->n_pathDistance + distanceEarthMiles(coord, previous->n_gCoord);
				n_priority = (oDistance - distanceEarthMiles(coord, end)) / n_pathDistance;		//priority assesses efficiency of current path
			}
		}
		
		//all NavHelpers assessed by priority
		bool operator <(const NavHelper& right) const
		{
			return n_priority < right.n_priority;
		}
		bool operator >(const NavHelper& right) const
		{
			return n_priority > right.n_priority;
		}
		bool operator ==(const NavHelper& right) const
		{
			return n_priority == right.n_priority;	//comparing priority for the sake of using a priority_queue, no NavHelpers are ever directly compared in a different setting
		}
		GeoCoord n_gCoord;
		double n_priority;
		NavHelper* n_prev;
		double n_pathDistance;
	};
	void constructDirections(NavHelper *nav, vector<NavSegment> &directions) const; //helper function to recursively construct directions
	SegmentMapper m_segMap;
	AttractionMapper m_attMap;
};

NavigatorImpl::NavigatorImpl()
{
}

NavigatorImpl::~NavigatorImpl()
{
}

bool NavigatorImpl::loadMapData(string mapFile)
{
	MapLoader tempLoader;
	if (!tempLoader.load(mapFile))
		return false;
	m_segMap.init(tempLoader);
	m_attMap.init(tempLoader);
	return true;
}

NavResult NavigatorImpl::navigate(string start, string end, vector<NavSegment> &directions) const
{
	GeoCoord gStart, gEnd;
	if (!m_attMap.getGeoCoord(start, gStart))
		return NAV_BAD_SOURCE;
	if (!m_attMap.getGeoCoord(end, gEnd))
		return NAV_BAD_DESTINATION;

	vector<StreetSegment> endingStreets = m_segMap.getSegments(gEnd);
	vector<GeoCoord> endingCoords;
	for (int k = 0; k < endingStreets.size(); k++)
	{
		endingCoords.push_back(endingStreets[k].segment.end);
		endingCoords.push_back(endingStreets[k].segment.start);
	}

	const double originalDistance = distanceEarthMiles(gStart, gEnd);	//constant used to calculate priority
	priority_queue<NavHelper> navQueue;
	MyMap<GeoCoord, NavHelper> visited;
	NavHelper navStart(gStart, gEnd, nullptr, originalDistance);	
	navQueue.push(navStart);
	bool hasReachedEnd = false;

	while (!navQueue.empty())
	{
		NavHelper *current;	//this will end up pointing to the navQueue.top() item once it is placed in visited, so its memory location does not change
		NavHelper *existing = visited.find(navQueue.top().n_gCoord);
		if (existing != nullptr && navQueue.top().n_pathDistance >= existing->n_pathDistance)	//if node has been visited and the current path is longer, throw it out
		{
			navQueue.pop();
			continue;
		}
		visited.associate(navQueue.top().n_gCoord, navQueue.top());		//top of queue has a better path so replace the existing one
		if (existing == nullptr)	//only call find if it needs to
			current = visited.find(navQueue.top().n_gCoord);
		else
			current = existing;
		navQueue.pop();

		for (int k = 0; k < endingCoords.size(); k++)	//check if current is one step away from the end
			if (endingCoords[k] == current->n_gCoord)
				hasReachedEnd = true;
		
		if (hasReachedEnd)
		{
			if (directions.size() != 0)
				directions.clear();
			NavHelper navEnd(gEnd, gEnd, current, originalDistance);	//construct ending NavHelper for the purpose of constructing a full path
			constructDirections(&navEnd, directions);
			return NAV_SUCCESS;
		}

		vector<StreetSegment> streets = m_segMap.getSegments(current->n_gCoord);
		for (int k = 0; k < streets.size(); k++)
		{
			//do not evaluate coordinates at current coordinate or the current coordinate's previous coordinate
			if (streets[k].segment.start != current->n_gCoord && (current->n_prev == nullptr || streets[k].segment.start != current->n_prev->n_gCoord))
			{
				NavHelper sTemp(streets[k].segment.start, gEnd, current, originalDistance);
				navQueue.push(sTemp);
			}
			if (streets[k].segment.end != current->n_gCoord && (current->n_prev == nullptr || streets[k].segment.end != current->n_prev->n_gCoord))
			{
				NavHelper eTemp(streets[k].segment.end, gEnd, current, originalDistance);
				navQueue.push(eTemp);
			}
		}
	}	
	return NAV_NO_ROUTE;
}

//recursive directions constructor
//looks at a node and the two before it
//base case is the node after the starting node, so the third node is a nullptr
//constructs direcions from begining to end
void NavigatorImpl::constructDirections(NavHelper *nav, vector<NavSegment> &directions) const
{
	vector<StreetSegment> streets2 = m_segMap.getSegments(nav->n_gCoord);
	vector<StreetSegment> streets1 = m_segMap.getSegments(nav->n_prev->n_gCoord);
	string street2Name = findCommonStreetName(streets1, streets2);
	if (nav->n_prev->n_prev != nullptr)		//only turn if not the base case
	{

		constructDirections(nav->n_prev, directions);

		vector<StreetSegment> streets0 = m_segMap.getSegments(nav->n_prev->n_prev->n_gCoord);
		string street1Name = findCommonStreetName(streets0, streets1);

		if (street1Name != street2Name)		//all segments have some angle not equal to 180 degrees between them, so only check for a street name change for a turn
		{
			NavSegment turn(coordsToTurnDirection(nav->n_prev->n_prev->n_gCoord, nav->n_prev->n_gCoord, nav->n_gCoord), street2Name);
			directions.push_back(turn);
		}
	}
	GeoSegment segToTravel(nav->n_prev->n_gCoord, nav->n_gCoord);
	NavSegment proceed(coordsToDirection(nav->n_prev->n_gCoord, nav->n_gCoord), street2Name, nav->n_pathDistance - nav->n_prev->n_pathDistance, segToTravel);
	directions.push_back(proceed);
}

//******************** Navigator functions ************************************

// These functions simply delegate to NavigatorImpl's functions.
// You probably don't want to change any of this code.

Navigator::Navigator()
{
    m_impl = new NavigatorImpl;
}

Navigator::~Navigator()
{
    delete m_impl;
}

bool Navigator::loadMapData(string mapFile)
{
    return m_impl->loadMapData(mapFile);
}

NavResult Navigator::navigate(string start, string end, vector<NavSegment>& directions) const
{
    return m_impl->navigate(start, end, directions);
}
