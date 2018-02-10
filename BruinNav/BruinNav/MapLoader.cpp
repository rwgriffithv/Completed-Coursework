#include "provided.h"
#include "support.h"
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
using namespace std;

class MapLoaderImpl
{
public:
	MapLoaderImpl();
	~MapLoaderImpl();
	bool load(string mapFile);
	size_t getNumSegments() const;
	bool getSegment(size_t segNum, StreetSegment& seg) const;
private:
	vector<StreetSegment> m_streets;
};

MapLoaderImpl::MapLoaderImpl()
{
}

MapLoaderImpl::~MapLoaderImpl()
{
}

bool MapLoaderImpl::load(string mapFile)
{
	string s;
	ifstream infile(mapFile);
	if (!infile)
	{
		cerr << "error: Cannot open " << mapFile << "!" << endl;
		return false;
	}
	while (getline(infile, s))
	{
		StreetSegment newSegment;
		newSegment.streetName = s;
		getline(infile, s);
		newSegment.segment = stringToSegment(s);
		getline(infile, s);
		int vSize = stoi(s);
		for (int k = 0; k < vSize; k++)
		{
			getline(infile, s);
			newSegment.attractions.push_back(stringToAttraction(s));
		}
		m_streets.push_back(newSegment);
	}
	return true;
}

size_t MapLoaderImpl::getNumSegments() const
{
	return m_streets.size();
}

bool MapLoaderImpl::getSegment(size_t segNum, StreetSegment &seg) const
{
	if (segNum < 0 || segNum >= m_streets.size())
		return false;
	seg = m_streets[segNum];
	return true;
}

//******************** MapLoader functions ************************************

// These functions simply delegate to MapLoaderImpl's functions.
// You probably don't want to change any of this code.

MapLoader::MapLoader()
{
	m_impl = new MapLoaderImpl;
}

MapLoader::~MapLoader()
{
	delete m_impl;
}

bool MapLoader::load(string mapFile)
{
	return m_impl->load(mapFile);
}

size_t MapLoader::getNumSegments() const
{
	return m_impl->getNumSegments();
}

bool MapLoader::getSegment(size_t segNum, StreetSegment& seg) const
{
   return m_impl->getSegment(segNum, seg);
}
