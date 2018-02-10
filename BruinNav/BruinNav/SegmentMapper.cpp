#include "provided.h"
#include "MyMap.h"
#include <vector>
using namespace std;

class SegmentMapperImpl
{
public:
	SegmentMapperImpl();
	~SegmentMapperImpl();
	void init(const MapLoader& ml);
	vector<StreetSegment> getSegments(const GeoCoord& gc) const;
private:
	MyMap<GeoCoord, vector<StreetSegment>> m_segments;
};

SegmentMapperImpl::SegmentMapperImpl()
{
}

SegmentMapperImpl::~SegmentMapperImpl()
{
}

void SegmentMapperImpl::init(const MapLoader& ml)
{
	for (int k = 0; k < ml.getNumSegments(); k++)
	{
		StreetSegment temp;
		vector<StreetSegment> nVector;
		ml.getSegment(k, temp);
		for (int j = 0; j < temp.attractions.size(); j++)	//get attraction coordinates
		{
			if (m_segments.find(temp.attractions[j].geocoordinates) == nullptr)
				m_segments.associate(temp.attractions[j].geocoordinates, nVector);
			m_segments.find(temp.attractions[j].geocoordinates)->push_back(temp);
		}		

		if (m_segments.find(temp.segment.start) == nullptr)		//get street start coordinate
		m_segments.associate(temp.segment.start, nVector);
		m_segments.find(temp.segment.start)->push_back(temp);

		if (m_segments.find(temp.segment.end) == nullptr)		//get street end coordinate
			m_segments.associate(temp.segment.end, nVector);
		m_segments.find(temp.segment.end)->push_back(temp);
	}
}

vector<StreetSegment> SegmentMapperImpl::getSegments(const GeoCoord& gc) const
{
	const vector<StreetSegment> *tempPointer = m_segments.find(gc);
	if (tempPointer == nullptr)
	{
		vector<StreetSegment> empty;
		return empty;
	}
	return *tempPointer;
}

//******************** SegmentMapper functions ********************************

// These functions simply delegate to SegmentMapperImpl's functions.
// You probably don't want to change any of this code.

SegmentMapper::SegmentMapper()
{
	m_impl = new SegmentMapperImpl;
}

SegmentMapper::~SegmentMapper()
{
	delete m_impl;
}

void SegmentMapper::init(const MapLoader& ml)
{
	m_impl->init(ml);
}

vector<StreetSegment> SegmentMapper::getSegments(const GeoCoord& gc) const
{
	return m_impl->getSegments(gc);
}
