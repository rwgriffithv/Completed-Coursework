// MyMap.h
#ifndef	MYMAP_INCLUDED
#define MYMAP_INCLUDED

#include "support.h"
// Skeleton for the MyMap class template.  You must implement the first six
// member functions.

template<typename KeyType, typename ValueType>
class MyMap
{
public:
	MyMap():m_head(nullptr), m_size(0) {}
	~MyMap()
	{
		clear();
	}
	void clear()
	{
		clearHelper(m_head);
	}
	int size() const
	{
		return m_size;
	}
	void associate(const KeyType& key, const ValueType& value)
	{
		associateHelper(key, value, m_head);
	}

	  // for a map that can't be modified, return a pointer to const ValueType
	const ValueType* find(const KeyType& key) const
	{
		Node* current = m_head;
		while (current != nullptr)
		{
			if (key == current->n_key)
				return &current->n_value;
			if (key > current->n_key)
				current = current->n_rChild;
			else
				current = current->n_lChild;
		}
		return nullptr;
	}

	  // for a modifiable map, return a pointer to modifiable ValueType
	ValueType* find(const KeyType& key)
	{
		return const_cast<ValueType*>(const_cast<const MyMap*>(this)->find(key));
	}

	  // C++11 syntax for preventing copying and assignment
	MyMap(const MyMap&) = delete;
	MyMap& operator=(const MyMap&) = delete;

private:
	struct Node
	{
		Node(KeyType key, ValueType value) :n_key(key), n_value(value), n_lChild(nullptr), n_rChild(nullptr) {}
		KeyType n_key;
		ValueType n_value;
		Node* n_lChild;
		Node* n_rChild;
	};
	void clearHelper(Node* node)	//recursive clear function
	{
		if (node == nullptr)
			return;
		clearHelper(node->n_lChild);
		clearHelper(node->n_rChild);
		delete node;
	}
	void associateHelper(const KeyType& key, const ValueType& value, Node* &node)	//recursive associate function
	{
		if (node == nullptr)
		{
			node = new Node(key, value);
			m_size++;
			return;
		}
		if (node->n_key == key)
			node->n_value = value;
		else
		{
			if (key > node->n_key)
				associateHelper(key, value, node->n_rChild);
			else
				associateHelper(key, value, node->n_lChild);
		}
	}
	int m_size;
	Node* m_head;
};

#endif