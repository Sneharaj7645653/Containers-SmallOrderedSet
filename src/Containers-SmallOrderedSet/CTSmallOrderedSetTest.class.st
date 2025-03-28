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
CTSmallOrderedSetTest >> testDoSeparatedBy [ 
    | seen |

    "Add elements manually, including duplicates"
    collection add: 2.
    collection add: 1.
    collection add: 3.
    collection add: 2.  "Duplicate"
    collection add: 1.  "Duplicate"

    "Verify that collection size is correct (duplicates should not be counted)"
    self assert: collection size equals: 3.

    "Iterate over the collection, inserting separators"
    seen := Array streamContents: [ :stream |
        collection do: [ :each | stream nextPut: each ] 
                  separatedBy: [ stream nextPut: '-' ] ].

    "Ensure separators are added correctly and duplicates are not present"
    self assert: seen equals: #(2 '-' 1 '-' 3).

]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testErrorNotFound [ 
    | collectionSet emptyCollection errorFlagEmpty errorFlagNonExistent errorFlagAlreadyRemoved |

    "Create an instance of CTSmallOrderedSet"
    collectionSet := CTSmallOrderedSet new: 2.

    "Try removing an element from an empty set"
    emptyCollection := CTSmallOrderedSet new: 0.
    errorFlagEmpty := false.
    ([
        emptyCollection remove: 42. "Removing from empty set"
    ]) on: Error do: [ :ex | errorFlagEmpty := true. ].
    self assert: errorFlagEmpty.  "Ensure an error is raised for empty set"

    "Try removing a non-existent element from a non-empty set"
    collectionSet add: 1.
    collectionSet add: 2.
    errorFlagNonExistent := false.
    ([
        collectionSet remove: 999.  "Non-existent element"
    ]) on: Error do: [ :ex | errorFlagNonExistent := true. ].
    self assert: errorFlagNonExistent.  "Ensure an error is raised for non-existent element"

    "Try removing the same element twice"
    collectionSet remove: 1.
    errorFlagAlreadyRemoved := false.
    ([
        collectionSet remove: 1.  "Already removed"
    ]) on: Error do: [ :ex | errorFlagAlreadyRemoved := true. ].
    self assert: errorFlagAlreadyRemoved.  "Ensure an error is raised for re-removal"


]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testFindIndexFor [ 
    | indexAbsent indexFirst indexMiddle indexLast indexSingle indexNegative indexSpecial |

    "Case 1: Empty Collection"
    self assert: (collection findIndexFor: 42) equals: 0.

    "Case 2: Single Element Collection"
    collection add: 100.
    indexSingle := collection findIndexFor: 100.
    self assert: indexSingle equals: 1.

    "Case 3: Standard Ordered Collection"
    collection addAll: #(10 20 30 40 50).
    indexFirst := collection findIndexFor: 10.
    indexMiddle := collection findIndexFor: 30.
    indexLast := collection findIndexFor: 50.

    "Assert correct indexes"
    self assert: indexFirst equals: 2.  "Since 100 is first now"
    self assert: indexMiddle equals: 4.
    self assert: indexLast equals: 6.

    "Case 4: Searching for a Non-Existent Element"
    indexAbsent := collection findIndexFor: 99.
    self assert: indexAbsent equals: 0.

    "Case 5: Handling Negative Numbers"
    collection add: -5.
    indexNegative := collection findIndexFor: -5.
    self assert: indexNegative equals: collection size.

    "Case 6: Handling Special Characters"
    collection add: '$%#@!'.
    indexSpecial := collection findIndexFor: '$%#@!'.
    self assert: indexSpecial equals: collection size.

]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testGrow [ 
    | initialCapacity elementsBeforeGrow elementsAfterGrow expectedSize sizeAfterDuplicates zeroCapacitySet |

    "Create a small set with a fixed capacity"
    collection := CTSmallOrderedSet new: 2.  "Initial capacity = 2"
    initialCapacity := 2.
    "Add elements up to the initial limit"
    collection add: 1.
    collection add: 2.

    "Store elements before triggering grow"
    elementsBeforeGrow := collection asArray.

    "Ensure that collection reached its initial capacity"
    self assert: collection size equals: initialCapacity.

    "Add one more element to force growth"
    collection add: 3.

    "Store elements after growth"
    elementsAfterGrow := collection asArray.

    "Calculate expected size (since we added 3 unique elements)"
    expectedSize := 3.

    "Assert that the collection size increased"
    self assert: (collection size > initialCapacity).

    "Assert that the collection size is exactly what we expect"
    self assert: collection size equals: expectedSize.

    "Verify all original elements are still in order"
    self assert: (elementsAfterGrow copyFrom: 1 to: elementsBeforeGrow size) equals: elementsBeforeGrow.

    "Ensure the newly added element exists"
    self assert: (collection includes: 3).

    "Store size before attempting to add duplicates"
    sizeAfterDuplicates := collection size.

    "Try adding duplicates"
    collection add: 2.  "Duplicate"
    collection add: 1.  "Duplicate"
    collection add: 3.  "Duplicate"

    "Assert that size does not increase when adding duplicates"
    self assert: collection size equals: sizeAfterDuplicates.

    "Ensure that duplicates were not added and order remains unchanged"
    self assert: (collection asArray) equals: #(1 2 3).

    "Edge Case: Force another growth by adding new elements"
    collection add: 4.
    collection add: 5.
    collection add: 6.  "Should trigger another growth"

    "Verify the collection still maintains order after multiple growths"
    self assert: (collection asArray) equals: #(1 2 3 4 5 6).

    "Test Zero-Capacity Initialization"
    zeroCapacitySet := CTSmallOrderedSet new: 0.  "Initially empty with no preallocated space"
    self assert: zeroCapacitySet isEmpty.  "Ensure it's empty initially"

    "Ensure elements can be added and size increases dynamically"
    zeroCapacitySet add: 10.
    zeroCapacitySet add: 20.
    zeroCapacitySet add: 30.

    "Verify growth occurs from zero capacity"
    self assert: zeroCapacitySet size equals: 3.
    self assert: (zeroCapacitySet asArray) equals: #(10 20 30).

]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testIncludes [
	self deny: (collection includes: 0).
	collection add: 0.
	self assert: (collection includes: 0)
]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testInitialize [ 
    | defaultSet customSet zeroCapacitySet initialCapacity |

    "Test default initialization"
    defaultSet := CTSmallOrderedSet new.
    self assert: defaultSet isEmpty.
    self assert: defaultSet size equals: 0. "Ensure it's empty upon creation"

    "Test custom capacity initialization"
    initialCapacity := 5.
    customSet := CTSmallOrderedSet new: initialCapacity.
    self assert: customSet isEmpty.

    "Ensure elements can be added up to initial capacity"
    customSet addAll: (1 to: initialCapacity).
    self assert: customSet size equals: initialCapacity.

    "Ensure set expands beyond initial capacity"
    customSet add: initialCapacity + 1.
    self assert: customSet size equals: initialCapacity + 1.

    "Test zero-capacity initialization (should still allow adding elements)"
    zeroCapacitySet := CTSmallOrderedSet new: 0.
    self assert: zeroCapacitySet isEmpty.  "Initially empty"

    "Ensure elements can be added even if initially zero capacity"
    zeroCapacitySet add: 1.
    zeroCapacitySet add: 2.
    self assert: zeroCapacitySet size equals: 2.
    self assert: (zeroCapacitySet includes: 1).
    self assert: (zeroCapacitySet includes: 2).

]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testIsCollection [ 
    | smallOrderedSet emptySet notCollectionObject |

    "Create an instance of CTSmallOrderedSet"
    smallOrderedSet := CTSmallOrderedSet new: 2.

    "Test if the collection is recognized as a collection"
    self assert: smallOrderedSet isCollection.

    "Test for an empty CTSmallOrderedSet instance"
    emptySet := CTSmallOrderedSet new: 0.
    self assert: emptySet isCollection.

    "Test a non-collection object"
    notCollectionObject := Object new.
    self assert: (notCollectionObject isCollection not).

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
CTSmallOrderedSetTest >> testPostCopy [ 
    | original clonedSet emptySet clonedEmptySet |

    "Create an instance and add elements"
    original := CTSmallOrderedSet new: 3.
    original addAll: #(1 2 3).

    "Create a cloned set"
    clonedSet := original copy.

    "Ensure the cloned set has the same elements"
    self assert: (clonedSet asArray) equals: #(1 2 3).

    "Modify the original and ensure the clone remains unchanged"
    original add: 4.
    self deny: (clonedSet includes: 4).

    "Modify the cloned set and ensure the original remains unchanged"
    clonedSet add: 5.
    self deny: (original includes: 5).

    "Test cloning an empty set"
    emptySet := CTSmallOrderedSet new: 0.
    clonedEmptySet := emptySet copy.
    self assert: clonedEmptySet isEmpty.

    "Test that cloning does not introduce duplicates"
    original add: 2.  "Duplicate"
    self assert: original size equals: 4.  "Ensuring duplicate was not added"
    self assert: clonedSet size equals: 4.  "Ensuring clone remains unchanged"

    "Ensure deep copy: Modify internal table and verify no effect"
    clonedSet := original copy.
    original add: 6.
    self deny: (clonedSet includes: 6).

]

{ #category : 'testing' }
CTSmallOrderedSetTest >> testPrivateAdd [ 
    | collectionSet tableBefore tableAfter |

    "Create a set with a small initial capacity to trigger `privateAdd:` execution sooner"
    collectionSet := CTSmallOrderedSet new: 2.

    "Ensure the collection is empty initially"
    self assert: collectionSet isEmpty.

    "Add two elements - should NOT trigger `grow`, but will invoke `privateAdd:`"
    collectionSet add: 1.
    collectionSet add: 2.

    "Capture the table size before a forced growth"
    tableBefore := collectionSet size.

    "Force `privateAdd:` to trigger growth by adding a third element"
    collectionSet add: 3.

    "Verify that the collection has grown as expected"
    tableAfter := collectionSet size.
    self assert: tableAfter > tableBefore.  "Ensures `grow` was called by `privateAdd:`"

    "Verify that all added elements are present and maintain their order"
    self assert: (collectionSet asArray) equals: #(1 2 3).

    "Ensure `privateAdd:` does not remove or overwrite existing elements"
    self assert: (collectionSet includes: 1).
    self assert: (collectionSet includes: 2).
    self assert: (collectionSet includes: 3).

    "Verify that `privateAdd:` alone does not handle duplicates (handled by `add:`)"
    collectionSet add: 2.  "Attempt to add a duplicate"
    self assert: collectionSet size equals: 3.  "Size remains unchanged as `add:` prevents duplicates"

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
CTSmallOrderedSetTest >> testRemoveIndex [ 

	| collectionSet |
	"Create a set and add some elements"
	collectionSet := CTSmallOrderedSet new: 5.
	collectionSet add: 1.
	collectionSet add: 2.
	collectionSet add: 3.
	collectionSet add: 4.

	"Remove an element by index"
	collectionSet removeIndex: 2.


	"Test that the collection size decreased"
	self assert: collectionSet size equals: 3.
	self assert: (collectionSet asArray) equals: #( 1 3 4 ).
	"Test that the removed element is no longer in the collection"
	self deny: (collectionSet includes: 2).

	"Test removing from an empty set"
	collectionSet := CTSmallOrderedSet new: 0.
	self should: [ collectionSet removeIndex: 1 ] raise: Error.

	"Test removing from an empty set with error message"
	collectionSet := CTSmallOrderedSet new: 0.


	"Test removing the first index"
	collectionSet := CTSmallOrderedSet new: 3.
	collectionSet add: 1.
	collectionSet add: 2.
	collectionSet add: 3.
	collectionSet removeIndex: 1.
	self assert: collectionSet size equals: 2.
	self assert: (collectionSet asArray) equals: #( 2 3 ).

	"Test removing the last index"
	collectionSet := CTSmallOrderedSet new: 3.
	collectionSet add: 1.
	collectionSet add: 2.
	collectionSet add: 3.
	collectionSet removeIndex: 3.
	self assert: collectionSet size equals: 2.
	self assert: (collectionSet asArray) equals: #( 1 2 ).

	"Test removing an index out of bounds"
	collectionSet := CTSmallOrderedSet new: 3.
	collectionSet add: 1.
	collectionSet add: 2.
	collectionSet add: 3.
	self should: [ collectionSet removeIndex: 4 ] raise: Error.

	"Test removing the only element in the set"
	collectionSet := CTSmallOrderedSet new: 1.
	collectionSet add: 1.
	collectionSet removeIndex: 1.
	self assert: collectionSet isEmpty.
	self assert: collectionSet size equals: 0


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
