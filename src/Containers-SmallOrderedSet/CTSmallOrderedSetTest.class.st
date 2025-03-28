Class {
	#name : 'CTSmallOrderedSetTest',
	#superclass : 'TestCase',
	#instVars : [
		'collection'
	],
	#category : 'Containers-SmallOrderedSet',
	#package : 'Containers-SmallOrderedSet'
}

{ #category : 'configuration' }
CTSmallOrderedSetTest >> collectionClass [
	^ CTSmallOrderedSet
]

{ #category : 'running' }
CTSmallOrderedSetTest >> setUp [
	super setUp.
	collection := CTSmallOrderedSet new
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testAdd [
	| object |
	object := Object new.
	self assert: collection size equals: 0.
	self assert: (collection add: object) equals: object.
	self assert: collection size equals: 1.
	self assert: (collection add: object) equals: object
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testAddAll [
	collection addAll: #(2 1 1).
	self assert: collection size equals: 2.
	self assert: (collection includes: 1).
	self assert: (collection includes: 2)
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testAddAllKeepsOrder [
	collection addAll: #(2 1 1 3 4 5 5 5 6).
	self assert: collection size equals: 6.
	self assert: collection asArray equals: #(2 1 3 4 5 6).
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testAsArray [
	collection addAll: #(2 1 1).
	self assert: collection asArray equals: #(2 1).
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testAsArrayWithStrangeOrder [
	collection addAll: #(2 1 3 2 1).
	self assert: collection asArray equals: #(2 1 3).
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testCopy [
	| copy |
	collection add: 1.
	copy := collection copy.
	collection add: 2.
	
	self assert: collection size equals: 2.
	self assert: copy size equals: 1.
	
	self assert: (collection includes: 2).
	self deny: (copy includes: 2).
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testDo [
	| seen |
	collection addAll: #(2 1 1).
	seen := Array streamContents: [ :stream |
		collection do: [ :each |
			stream nextPut: each ] ].
	self assert: seen size equals: 2.
	self assert: (seen at: 1) equals: 2.
	self assert: (seen at: 2) equals: 1
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testIncludes [
	self deny: (collection includes: 0).
	collection add: 0.
	self assert: (collection includes: 0)
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testIsEmpty [
	self assert: collection isEmpty.
	collection add: 1.
	self deny: collection isEmpty.
	collection remove: 1.
	self assert: collection isEmpty
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testRemove [
	collection add: 1.
	self assert: (collection remove: 1) equals: 1.
	self should: [ collection remove: 1 ] raise: Error
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testRemoveIfAbsent [
	| absent |
	collection add: 1.
	absent := false.
	
	self assert: (collection remove: 1 ifAbsent: [ absent := true ]) equals: 1.
	self deny: absent.
	
	collection remove: 1 ifAbsent: [ absent := true ].
	self assert: absent.
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testSize [
	self assert: collection size equals: 0.
	collection addAll: #(2 1 1).
	self assert: collection size equals: 2.
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testWithAll [ 
    | emptySet singleSet duplicateSet orderedSet mixedSet largeSet unorderedSet specialCharSet expected |

    "Empty Collection Input"
    emptySet := CTSmallOrderedSet withAll: #().
    self assert: emptySet isEmpty.

    "Single Element Collection"
    singleSet := CTSmallOrderedSet withAll: #(42). 
    self assert: singleSet size equals: 1.
    self assert: (singleSet includes: 42).

    "Collection With Only Duplicates"
    duplicateSet := CTSmallOrderedSet withAll: #(7 7 7 7 7).
    self assert: duplicateSet size equals: 1.
    self assert: (duplicateSet includes: 7).

    "Already Ordered Input"
    orderedSet := CTSmallOrderedSet withAll: #(10 20 30).
    expected := #(10 20 30).
    self assert: orderedSet asArray equals: expected.

    "Mixed Data Types"
    mixedSet := CTSmallOrderedSet withAll: #(1 'a' 2 'b' 1 'a').
    self assert: mixedSet size equals: 4.
    self assert: (mixedSet includes: 1).
    self assert: (mixedSet includes: 'a').
    self assert: (mixedSet includes: 2).
    self assert: (mixedSet includes: 'b').

    "Large Input Collection"
    largeSet := CTSmallOrderedSet withAll: (1 to: 10000).
    self assert: largeSet size equals: 10000.

    "Unordered Input"
    unorderedSet := CTSmallOrderedSet withAll: #(5 2 8 1 3).
    self assert: unorderedSet asArray equals: #(5 2 8 1 3).

    "Collection With Special Characters"
    specialCharSet := CTSmallOrderedSet withAll: #('hello' 'world' 'hello!' 'world#').
    self assert: specialCharSet size equals: 4.
    self assert: (specialCharSet includes: 'hello!').
    self assert: (specialCharSet includes: 'world#').

]
