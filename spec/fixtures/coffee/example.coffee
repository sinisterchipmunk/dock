# A Person is a human and is usually given a name at birth.
class Person
  constructor: (name) ->
    @species = "human"
    @name = name
    
# A Girl is the female version of a Person.
class Girl extends Person
  constructor: (name) ->
    super name
    @sex = "female"

# A Boy is the male version of a Person.
class Boy extends Person
  constructor: (name) ->
    super name
    @sex = "male"

