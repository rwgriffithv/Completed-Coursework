#include "StudentWorld.h"
#include <string>
#include <vector>
#include <list>


GameWorld* createStudentWorld(std::string assetDir)
{
	return new StudentWorld(assetDir);
}

StudentWorld::~StudentWorld()
{
	cleanUp();
}

int StudentWorld::init()
{
	Field f;
	std::string fieldFile = getFieldFilename();
	std::string error;
	if (f.loadField(fieldFile, error) != Field::LoadResult::load_success)
	{
		setError(fieldFile + " " + error);
		return GWSTATUS_LEVEL_ERROR;
	}

	std::vector<std::string> fileNames = getFilenamesOfAntPrograms();
	
	for (int k = 4; k < fileNames.size();)
		fileNames.pop_back();

	std::string errorMsg;

	//remove any excess compilers from extra .bugs passed to the program
	for (int k = 0; k < fileNames.size(); k++)
	{
		m_comp.push_back(new Compiler);
		m_scores.push_back(0);	//initialize score
		if (!m_comp[k]->compile(fileNames[k], errorMsg))
		{
			setError(fileNames[k] + " " + errorMsg);
			return GWSTATUS_LEVEL_ERROR;
		}
	}

	int countAH[4]{ 0,0,0,0 }; //keep track of which anthills are in the field

	for (int x = 0; x < VIEW_WIDTH; x++)
	{
		for (int y = 0; y < VIEW_HEIGHT; y++)
		{
			Field::FieldItem item = f.getContentsOf(x, y);
			switch (item)
			{
			case Field::FieldItem::rock: actors[x][y].push_back(new Pebble(this, x, y)); break;
			case Field::FieldItem::water: actors[x][y].push_back(new WaterPool(this, x, y)); break;
			case Field::FieldItem::poison: actors[x][y].push_back(new Poison(this, x, y)); break;
			case Field::FieldItem::food: actors[x][y].push_back(new Food(this, x, y, 6000)); break;
			case Field::FieldItem::anthill0: if (m_comp.size() >= 1) { actors[x][y].push_back(new AntHill(this, x, y, IID_ANT_TYPE0, m_comp[0])); countAH[0]++; } break;
			case Field::FieldItem::anthill1: if (m_comp.size() >= 2) { actors[x][y].push_back(new AntHill(this, x, y, IID_ANT_TYPE1, m_comp[1])); countAH[1]++; } break;
			case Field::FieldItem::anthill2: if (m_comp.size() >= 3) { actors[x][y].push_back(new AntHill(this, x, y, IID_ANT_TYPE2, m_comp[2])); countAH[2]++; }break;
			case Field::FieldItem::anthill3: if (m_comp.size() == 4) { actors[x][y].push_back(new AntHill(this, x, y, IID_ANT_TYPE3, m_comp[3])); countAH[3]++; }break;
			case Field::FieldItem::grasshopper: actors[x][y].push_back(new BabyGrasshopper(this, x, y)); break;
			default: break;
			}
		}
	}

	//following code gets rid of compilers that were passed as arguments to the .exe but didn't have AntHills to initialize
	int k = 0;
	for (std::vector<Compiler*>::iterator itr = m_comp.begin(); itr != m_comp.end() && k < 4; k++)
	{
		if (countAH[k] == 0)
		{
			Compiler* temp = *itr;
			itr = m_comp.erase(itr);
			delete temp;
		}
		else
			itr++;
	}
	

	return GWSTATUS_CONTINUE_GAME;
}

int StudentWorld::move()
{
	m_tickCount--;
	for (int x = 0; x < VIEW_WIDTH; x++)
	{
		for (int y = 0; y < VIEW_HEIGHT; y++)
		{
			std::list<Actor*>::iterator itr;
			for (itr = actors[x][y].begin(); itr != actors[x][y].end();)
			{
				if ((*itr)->isDead())
				{
					if ((*itr)->isInsect())
						addFood(x, y, 100);
					itr++;
				}
				else
					if (!(*itr)->checkHasMoved())
					{
						(*itr)->doSomething();
						if ((*itr)->isInsect())
						{
							int ux = (*itr)->getX();
							int uy = (*itr)->getY();
							if (ux != x || uy != y)
							{
								(*itr)->registerMove();
								actors[ux][uy].push_back(*itr);
								itr = actors[x][y].erase(itr);
							}
							else
								itr++;
						}
						else
							itr++;
					}
					else
						itr++;
			}
		}
	}

	for (int x = 0; x < VIEW_WIDTH; x++)
	{
		for (int y = 0; y < VIEW_HEIGHT; y++)
		{
			for (std::list<Actor*>::iterator itr = actors[x][y].begin(); itr != actors[x][y].end();)
			{
				if ((*itr)->isDead())
				{
					Actor* temp = *itr;
					delete temp;
					itr = actors[x][y].erase(itr);
				}
				else
				{
					(*itr)->clearMove();
					itr++;
				}
			}
		}
	}

	setDisplayText();

	if (m_tickCount == 0)
	{
		if (m_scores.size() != 0 && m_scores[m_posCurrentWinner] > 5)
		{
			setWinner(m_comp[m_posCurrentWinner]->getColonyName());
			return GWSTATUS_PLAYER_WON;
		}
		else
			return GWSTATUS_NO_WINNER;
	}

	return GWSTATUS_CONTINUE_GAME;
}

void StudentWorld::setCurrentWinner()
{
	int pos = m_posCurrentWinner;
	for (int k = 0; k < m_scores.size(); k++)
	{
		if (m_scores[k] > m_scores[m_posCurrentWinner])
			m_posCurrentWinner = k;
	}
}

void StudentWorld::setDisplayText()
{
	std::ostringstream output;
	if (m_tickCount >= 0 && m_tickCount < 10)
		output << "Ticks:    ";
	else
	if (m_tickCount >= 10 && m_tickCount < 100)
		output << "Ticks:   ";
	else
	if (m_tickCount >= 100 && m_tickCount < 1000)
		output << "Ticks:  ";
	else
	if (m_tickCount >= 1000)
		output << "Ticks: ";
	
	output << m_tickCount << " -";
	if (m_comp.size() == 0)
		output << "  [No Ants]";
	else
		for (int k = 0; k < m_comp.size(); k++)
		{
			output << "  " << m_comp[k]->getColonyName();
			if (k == m_posCurrentWinner && m_scores[m_posCurrentWinner] > 5)
				output << "*";
			if (m_scores[k] >= 10)
				output << ": " << m_scores[k];
			else
				output << ": 0" << m_scores[k];
		}
	std::string complete = output.str();
	setGameStatText(complete);
}

void StudentWorld::cleanUp()
{
	for (int x = 0; x < VIEW_WIDTH; x++)
	{
		for (int y = 0; y < VIEW_HEIGHT; y++)
		{
			for (std::list<Actor*>::iterator itr = actors[x][y].begin(); itr != actors[x][y].end();)
			{
				Actor* temp = *itr;
				delete temp;
				itr = actors[x][y].erase(itr);
			}
		}
	}
	for (std::vector<Compiler*>::iterator itr = m_comp.begin(); itr != m_comp.end();)
	{
		Compiler* temp = *itr;
		delete temp;
		itr = m_comp.erase(itr);
	}
}

void StudentWorld::addActor(Actor* a)
{
	actors[a->getX()][a->getY()].push_back(a);
}

void StudentWorld::addFood(int x, int y, int amt)
{
	Food* food = getEdibleAt(x, y);
	if (food == nullptr)
		addActor(new Food(this, x, y, amt));
	else
		food->updateEnergy(amt);
}

bool StudentWorld::canMoveTo(int x, int y) const
{
	if (x < 0 || x >= 64 || y < 0 || y >= 64)
		return false;
	for (std::list<Actor*>::const_iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
	{
		if ((*itr)->blocksMovement())
			return false;
	}
	return true;
}


Food* StudentWorld::getEdibleAt(int x, int y) const
{
	for (std::list<Actor*>::const_iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
	{
		if ((*itr)->isEdible() && !(*itr)->isDead())
		{
			Food* food = dynamic_cast<Food*>(*itr);
			return food;
		}
	}
	return nullptr;
}

Pheromone* StudentWorld::getPheromoneAt(int x, int y, int colony) const
{
	for (std::list<Actor*>::const_iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
	{
		if ((*itr)->isPheromone(colony) && !(*itr)->isDead())
		{
			Pheromone* p = dynamic_cast<Pheromone*>(*itr);
			return p;
		}
	}
	return nullptr;
}


bool StudentWorld::isEnemyAt(int x, int y, int colony) const
{
	for (std::list<Actor*>::const_iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
	{
		if (!(*itr)->isDead() && (*itr)->isEnemy(colony))
			return true;
	}
	return false;
}

bool StudentWorld::isDangerAt(int x, int y, int colony) const
{
	for (std::list<Actor*>::const_iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
	{
		if (!(*itr)->isDead() && (*itr)->isDangerous(colony))
			return true;
	}
	return false;
}

bool StudentWorld::isAntHillAt(int x, int y, int colony) const
{
	for (std::list<Actor*>::const_iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
	{
		if (!(*itr)->isDead() && (*itr)->isMyHill(colony))
			return true;
	}
	return false;
}

bool StudentWorld::biteEnemyAt(Actor* me, int colony, int biteDamage)
{
	std::vector<Actor*> enemies;
	for (std::list<Actor*>::iterator itr = actors[me->getX()][me->getY()].begin(); itr != actors[me->getX()][me->getY()].end(); ++itr)
	{
		if (!(*itr)->isDead() && (*itr)->isEnemy(colony))
			enemies.push_back(*itr);
	}
	if (enemies.size() == 0)
		return false;
	enemies[randInt(0, enemies.size() - 1)]->getBitten(biteDamage);
	return true;
}


void StudentWorld::poisonAllPoisonableAt(int x, int y)
{
	for (std::list<Actor*>::iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
		(*itr)->getPoisoned();
}

void StudentWorld::stunAllStunnableAt(int x, int y)
{
	for (std::list<Actor*>::iterator itr = actors[x][y].begin(); itr != actors[x][y].end(); ++itr)
		(*itr)->getStunned();
}

void StudentWorld::increaseScore(int colony)
{
	m_scores[colony]++;
}