#include "Actor.h"
#include "StudentWorld.h"

//Actor Functions
bool Actor::isDead() const
{
	return false;
}

bool Actor::blocksMovement() const
{
	return false;
}

bool Actor::isEdible() const 
{ 
	return false; 
}

bool Actor::isPheromone(int colony) const 
{ 
	return false; 
}

bool Actor::isInsect() const 
{ 
	return false; 
}

bool Actor::isEnemy(int colony) const 
{ 
	return false; 
}

bool Actor::isDangerous(int colony) const 
{ 
	return isEnemy(colony); 
}


//EnergyHolder Function

int EnergyHolder::pickupAndEatFood(int amt)
{
	Food* food = getWorld()->getEdibleAt(getX(), getY());
	if (food == nullptr)
		return 0;
	if (amt > food->getEnergy())
		amt = food->getEnergy();
	m_energy += amt;
	food->updateEnergy(-amt);
	return amt;
}

//Pheremone Function
void Pheromone::doSomething()
{
	updateEnergy(-1);
}


void Pheromone::increaseStrength()
{
	if (getEnergy() + 256 > 768)
		updateEnergy(768 - getEnergy());
	else
		updateEnergy(256);
}

//AntHill Function
void AntHill::doSomething()
{
	updateEnergy(-1);
	if (isDead())
		return;
	if (pickupAndEatFood(10000) != 0)
		return;
	if (getEnergy() >= 2000)
	{
		getWorld()->addActor(new Ant(getWorld(), getX(), getY(), m_colony, m_antProgram, m_colony));
		//an ant's IID can be set as m_colony because they're equivalent values
		updateEnergy(-1500);
		getWorld()->increaseScore(m_colony);
		getWorld()->setCurrentWinner();
		//set current winner after each new ant is born, so the first colony to create the current record is the winner
	}
}

//WaterPool Function
void WaterPool::doSomething()
{
	getWorld()->stunAllStunnableAt(getX(), getY());
}

//Poison Function
void Poison::doSomething()
{
	getWorld()->poisonAllPoisonableAt(getX(), getY());
}

//Insect Food
void Insect::getXYInFrontOfMe(int& x, int& y) const
{
	switch (getDirection())
	{
	case right: x++; break;
	case left: x--; break;
	case up: y++; break;
	case down: y--; break;
	}
}

bool Insect::moveForwardIfPossible()
{
	int x = getX();
	int y = getY();
	getXYInFrontOfMe(x, y);
	if (getWorld()->canMoveTo(x, y))
	{
		moveTo(x, y);
		m_stunnedAtLocation = false;
		return true;
	}
	return false;
}

void Insect::getStunned()
{
	if (!m_stunnedAtLocation)
	{
		updateSleepTicks(2);
		m_stunnedAtLocation = true;
	}
}


//Ant Functions
void Ant::pickupFood(int amt)
{
	if (m_heldEnergy == 1800)
		return;
	Food* food = getWorld()->getEdibleAt(getX(), getY());
	if (food == nullptr)
		return;
	if (amt > food->getEnergy())
		amt = food->getEnergy();
	if (amt > 1800 - m_heldEnergy)
		amt = 1800 - m_heldEnergy;
	m_heldEnergy += amt;
	food->updateEnergy(-amt);
}


void Ant::doSomething()
{
	Insect::doSomething();

	if (getSleepTicks() > 0)
	{
		updateSleepTicks(-1);
		return;
	}

	Compiler::Command c;

	Pheromone* p; //declared for emitPheromone switch case
	int amtToEat = 100; //declared for eatFood switch case

	for (int k = 0; k < 10; k++)
	{
		if (!m_program->getCommand(m_instructionCount, c)) //fetch command
		{
			updateEnergy(-getEnergy());
			return;
		}
		int x = getX();
		int y = getY();

		switch (c.opcode)
		{
		case Compiler::Opcode::moveForward:
			if (moveForwardIfPossible())
			{
				m_prevBitten = false;
				m_prevBlocked = false;
			}
			else
				m_prevBlocked = true;
			m_instructionCount++;
			return;
		case Compiler::Opcode::eatFood:
			amtToEat = std::min(amtToEat, m_heldEnergy);
			updateEnergy(amtToEat);
			m_heldEnergy -= amtToEat;
			m_instructionCount++;
			return;
		case Compiler::Opcode::dropFood:
			getWorld()->addFood(x,y, m_heldEnergy);
			m_heldEnergy = 0;
			m_instructionCount++;
			return;;
		case Compiler::Opcode::bite:
			getWorld()->biteEnemyAt(this, m_colony, ANT_DAMAGE);
			m_instructionCount++;
			return;
		case Compiler::Opcode::pickupFood:
			pickupFood(400);
			m_instructionCount++;
			return;
		case Compiler::Opcode::emitPheromone:
			p = getWorld()->getPheromoneAt(x, y, m_colony);
			if (p == nullptr)
				getWorld()->addActor(new Pheromone(getWorld(), x, y, m_colony));
			else
				p->increaseStrength();
			m_instructionCount++;
			return;
		case Compiler::Opcode::faceRandomDirection:
			setDirection(randDirection());
			m_instructionCount++;
			return;
		case Compiler::Opcode::rotateClockwise:
			switch (getDirection())
			{
			case GraphObject::Direction::right: setDirection(down); break;
			case GraphObject::Direction::down: setDirection(left); break;
			case GraphObject::Direction::left: setDirection(up); break;
			case GraphObject::Direction::up: setDirection(right); break;
			}
			m_instructionCount++;
			return;
		case Compiler::Opcode::rotateCounterClockwise:
			switch (getDirection())
			{
			case GraphObject::Direction::right: setDirection(up); break;
			case GraphObject::Direction::down: setDirection(right); break;
			case GraphObject::Direction::left: setDirection(down); break;
			case GraphObject::Direction::up: setDirection(left); break;
			}
			m_instructionCount++;
			return;
		case Compiler::Opcode::generateRandomNumber:
			m_lastRandNum = randInt(0, convertOpToInt(c.operand1) - 1);
			m_instructionCount++;
			break;
		case Compiler::Opcode::goto_command:
			m_instructionCount = convertOpToInt(c.operand1);
			break;
		case Compiler::Opcode::if_command:
			switch (convertOpToInt(c.operand1))
			{
			case 0: //i_smell_danger_in_front_of_me
				getXYInFrontOfMe(x, y);
				if (getWorld()->isDangerAt(x, y, m_colony))
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 1: //i_smell_pheromone_in_front_of_me
				getXYInFrontOfMe(x, y);
				if (getWorld()->getPheromoneAt(x, y, m_colony) != nullptr)
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 2: //i_was_bit
				if (m_prevBitten)
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 3: //i_am_carrying_food
				if (m_heldEnergy > 0)
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 4: //i_am_hungry
				if (getEnergy() <= 25)
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 5: //i_am_standing_on_my_anthill
				if (getWorld()->isAntHillAt(x, y, m_colony))
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 6: //i_am_standing_on_food
				if (getWorld()->getEdibleAt(x, y) != nullptr)
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 7: //i_am_standing_on_an_enemy
				if (getWorld()->isEnemyAt(x, y, m_colony))
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 8: //i_was_blocked_from_moving
				if (m_prevBlocked)
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			case 9: //last_random_number_was_zero
				if (m_lastRandNum == 0)
					m_instructionCount = convertOpToInt(c.operand2);
				else
					m_instructionCount++;
				break;
			}
			break;
		}
	}
}

//Grasshopper Function
void Grasshopper::doSomething()
{
	Insect::doSomething();

	if (getSleepTicks() > 0)
	{
		updateSleepTicks(-1);
		return;
	}

	if (specificAction()) //varies for Adult and Baby grasshopppers
		return;

	if (pickupAndEatFood(200) != 0 && randInt(1, 20) % 2 == 0)
		//figured randInt is more consistent over a larger range, did this for all randInt calls
	{
		updateSleepTicks(2);
		return;
	}

	if (m_walkDistance == 0)
	{
		setDirection(randDirection());
		m_walkDistance = randInt(2, 10);
	}

	if (moveForwardIfPossible())
		m_walkDistance--;
	else
		m_walkDistance = 0;

	updateSleepTicks(2);
}

//AdultGrasshopper Functions
void AdultGrasshopper::getBitten(int amt)
{
	updateEnergy(-amt);
	if (isDead())
		return;
	if (randInt(1, 20) % 2 == 0) 
		getWorld()->biteEnemyAt(this, -1, ADULT_GRASSHOPPER_DAMAGE); 
		//passed -1 as colony so all ants return true when evaluated as enemies
}

bool AdultGrasshopper::specificAction()
{
	if (randInt(1, 30) % 3 == 0 && getWorld()->biteEnemyAt(this, -1, ADULT_GRASSHOPPER_DAMAGE))
	{
		updateSleepTicks(2);
		return true;
	}

	if (randInt(1, 100) % 10 == 0)
	{
		std::vector<std::pair<int, int>> coords;
		for (int x = getX() - 10; x <= getX() + 10; x++) //gets a square area around the AdultGrasshopper
		{
			for (int y = getY() - 10; y <= getY() + 10; y++)
			{
				if ((x - getX())*(x - getX()) + (y - getY())*(y - getY()) <= 100 && getWorld()->canMoveTo(x, y)) 
					//checks if space is within radius 10, and if there isn't a rock
				{
					coords.push_back(std::make_pair(x, y));
				}
			}
		}
		if (coords.size() != 0)
		{
			int pos = randInt(0, coords.size() - 1);
			moveTo(coords[pos].first, coords[pos].second);
			updateSleepTicks(2);
			return true;;
		}
	}
	return false;
}

bool BabyGrasshopper::specificAction()
{
	if (getEnergy() >= 1600)
	{
		getWorld()->addActor(new AdultGrasshopper(getWorld(), getX(), getY()));
		updateEnergy(-getEnergy());
		return true;
	}
	return false;
}

//Helper Functions

GraphObject::Direction randDirection()
{
	return (GraphObject::Direction)randInt(1, 4);
}

int convertOpToInt(std::string s)
{
	int op1 = 0;
	for (int k = 0; k < s.size(); k++)
		op1 += (s[k] - '0') * (int)pow(10, s.size() - k - 1);
	return op1;
}
