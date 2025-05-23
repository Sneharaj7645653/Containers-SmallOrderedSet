# Containers-SmallOrderedSet

<a href="https://www.pharo.org">
    <img alt="Pharo" src="https://img.shields.io/static/v1?style=for-the-badge&message=Pharo&color=3297d4&logo=Harbor&logoColor=FFFFFF&label=" />
</a>

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
![https://github.com/pharo-containers/Containers-SmallOrderedSet/workflows/matrix/badge.svg](https://github.com/pharo-containers/Containers-SmallOrderedSet/workflows/matrix/badge.svg)
![https://github.com/pharo-containers/Containers-SmallOrderedSet/workflows/currentStablePharo/badge.svg](https://github.com/pharo-containers/Containers-SmallOrderedSet/workflows/currentStablePharo/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/pharo-containers/Containers-SmallOrderedSet/badge.svg?branch=master)](https://coveralls.io/github/pharo-containers/Containers-SmallOrderedSet?branch=master)

A simple implementation 

This package is part of the Containers project: This project is to collect, clean, 
test and document alternate collection datastructures. Each package is modular so that users 
can only load the collection they need without 100 of related collections.

## Loading

```smalltalk
Metacello new
  baseline: 'ContainersSmallOrderedSet';
  repository: 'github://pharo-containers/Containers-SmallOrderedSet/src';
  load.
```

## If you want to depend on it

```smalltalk
  spec 
    baseline: 'ContainersSmallOrderedSet' 
    with: [ spec repository: 'github://pharo-containers/Containers-SmallOrderedSet/src' ].
  ```

----
The best way to predict the future is to do it!
Less talking more doing. stephane.ducasse@inria.fr
