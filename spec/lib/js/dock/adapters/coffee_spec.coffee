require 'spec_helper'
fs = require 'fs'

TEST_FILE = fs.readFileSync('spec/fixtures/coffee/example.coffee').toString()

describe "Coffee adapter", ->
  subject = null

  describe "classes", ->
    beforeEach -> subject = doc TEST_FILE
    
    it "should discover all classes", ->
      expect(c.name for c in subject.classes).toEqual ['Person', 'Girl', 'Boy']
    
    it "should attach only the relative filename", ->
      expect(subject.classes[0].file).toEqual 't.coffee'
    
    it "should discover the correct instance methods", ->
      expect(subject.classes[0].instance_methods[1].name).toEqual 'sayHello'
    
    it "should discover the correct class methods", ->
      expect(subject.classes[0].class_methods[0].name).toEqual 'getSpecies'
    
    it "should create class level documentation", ->
      expect(subject.classes[0].documentation.length).not.toEqual 0
    
  	it "should discover params for methods that have them", ->
  	  expect(subject.classes[0].instance_methods[0].params.length).not.toEqual 0
  	
  	it "should populate each class with its language", ->
  	  for klass in subject.classes
  	    expect(klass.language).toEqual 'coffee'
  
  it "should not croak on accessors", ->
    expect(-> doc '{}.x').not.toThrow()
    
  it "should not croak on elses", ->
    expect(-> doc 'if 1 then 0 else 1').not.toThrow()
    
  it "should not croak on whiles", ->
    expect(-> doc '1 while 0').not.toThrow()
  
  it "should not croak on inverted ops", ->
    expect(-> doc '"" !instanceof String').not.toThrow()
  
  it "should not croak in a file with only comments", ->
    expect(-> doc "# comment").not.toThrow()
  
  it "should discover exported classes", ->
    d = doc "exports.Code = class Code\n  constructor: ->"
    expect(d.classes[0].name).toEqual 'Code'
  
  it "should document exported classes", ->
    d = doc "###\nCODE!\n###\nexports.Code = class Code\n  constructor: ->"
    expect(d.classes[0].documentation).toMatch /CODE\!/
  
  it "should not croak on assigns to non-classes", ->
    expect(-> doc "exports.Code = 1").not.toThrow()
