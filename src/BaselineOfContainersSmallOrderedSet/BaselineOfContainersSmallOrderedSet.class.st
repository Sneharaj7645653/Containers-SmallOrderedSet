"
A baseline for https://github.com/pharo-contributions/BitmapCharacterSet
"
Class {
	#name : 'BaselineOfContainersSmallOrderedSet',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfContainersSmallOrderedSet',
	#package : 'BaselineOfContainersSmallOrderedSet'
}

{ #category : 'baselines' }
BaselineOfContainersSmallOrderedSet >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		spec 
			package: 'Containers-SmallOrderedSet'.
			
		"Groups"	
		spec				
				group: 'Core' with: #('Containers-SmallOrderedSet');
				group: 'all' with: #('Core');
				group: 'default' with: #('all')	
	]
]
