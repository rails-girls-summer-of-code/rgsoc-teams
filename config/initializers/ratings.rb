# WOMEN_PRIORITY = [
#   [10, '2 women pair'] ,
#   [5, 'mixed pair or single women'],
#   [0, 'men pair']
# ]
#
# PRACTICE_TIME = [
#   [0, 'less than a month'],
#   [1, '1-3 months'],
#   [2, '3-6 months'],
#   [4, '6-9 months'],
#   [8, '9-12 months'],
#   [10, 'more than 12 months']
# ]
#
# SUPPORT = [
#   [10, 'fulltime support'],
#   [8, '5-8 hours a day'],
#   [5, '3-4 hours a day'],
#   [3, '1-2 hours a day'],
#   [1, '1 hour a day']
# ]
#
# PLANNING = [
#   [5,  'has a proper is a plan'],
#   [1,  'project named or week plan'],
#   [0,  'project undecided']
# ]

WOMEN_PRIORITY = [
  [0, '2 women pair'],
  [1, 'mixed pair or single women'],
  [2, 'men pair']
]

PRACTICE_TIME = [
  [0, 'more than 12 months'],
  [1, '9-12 months'],
  [2, '6-9 months'],
  [3, '3-6 months'],
  [4, '1-3 months'],
  [5, 'less than a month'],
]

SKILL_LEVELS = [
  [0, '5: Is used to refactoring'],
  [1, '4: Has contributed to Open Source'],
  [2, '3: Can write a unit test'],
  [3, '2: Can write a method'],
  [4, '1: Knows data types'],
]

SUPPORT = [
  [0, 'fulltime support'],
  [1, '5-6 hours a day'],
  [2, '3-4 hours a day'],
  [3, '1-2 hours a day'],
  [4, '1 hour a day']
]

PLANNING = [
  [0,  'has a proper is a plan'],
  [1,  'project named or weak plan'],
  [2,  'project undecided']
]

WEIGHTS = {
  practice_time: [10, 6, 3, 2, 1, 0],
  skill_level:   [10, 6, 3, 1, 0],
  support:       [10, 8, 6, 4, 2],
  planning:      [10, 6, 0]
}

SPONSOR_PICK = 20
MENTOR_PICK = 10
