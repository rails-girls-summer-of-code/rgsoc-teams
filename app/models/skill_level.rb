# frozen_string_literal: true

class SkillLevel
  MATRIX = {
    1   => ['I understand and can explain the difference between data types (strings, booleans, integers)',
            'I have heard of the MVC (Model View Controller) pattern',
            'I am comfortable creating and deleting files from the command line'],
    2   => ['I am confident writing a simple method',
            'I am familiar with the concept of TDD and can explain what it stands for',
            'I am able to write a counter that loops through numbers (e.g. from one to ten)'],
    3   => ['I am comfortable solving a merge conflict in git',
            'I am confident with the vocabulary to use when looking up a solution to a computing problem',
            'I feel confident explaining the components of MVC (and their roles)',
            'I understand what an HTTP status code is',
            'I have written a unit test before'],
    4   => ['I have written a script to automate a task before',
            'I have already contributed original code to an Open Source project',
            'I can explain the difference between public, protected and private methods',
            'I am familiar with more than one testing tool'],
    5   => ['I have heard of and used Procs in my code before',
            'I feel confident doing test-driven development in my projects',
            'I have gotten used to refactoring code']
  }

  class << self
    def each(&block)
      MATRIX.each(&block)
    end

    def map(&block)
      MATRIX.map(&block)
    end
  end
end
