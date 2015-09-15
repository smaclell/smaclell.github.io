---
layout: post
title:  "Test Cases Made Simple"
date:   2015-09-16 01:19:07
tags: testing code
---

I often find my test look very similar. The behaviour of the tests are
exactly the same with different input and output data. Test cases in [NUnit][nunit]
are a great way to combine tests with different test values and the same behaviour.

In order to demo test cases I will be using a simple ``StringCalculator`` based
on the [String Calculator kata][kata]. The class, ``StringCalculator`` has one
method ``Add`` which takes in a string containing delimited numbers as input
and returns the sum of the numbers.

Each test case would call ``Add`` with input then verify the total. Using test
cases we can easily add new cases and show how the input and totals are related.

If I was to write these tests without using test cases I would need to repeat
nearly identical code for each test. You can see this with two simple tests
shown below:

{% highlight csharp %}
using NUnit.Framework;

public class SimpleStringCalculatorTests {

    [Test]
    public void Add_EmptyString_ReturnsZero() {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( "" );

        Assert.AreEqual( 0, total );
    }

    [Test]
    public void Add_SingleNumber_ReturnsTheNumber() {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( "1" );

        Assert.AreEqual( 1, total );
    }

    [Test]
    public void Add_TwoNumbers_ReturnsTheTotal() {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( "1,2" );

        Assert.AreEqual( 3, total );
    }
}
{% endhighlight %}

We can do better. Using the various test case attributes we can dramatically
reduce the duplicate code in the tests. By parameterizing each test we can
provide data for each case we care about.

### TestCase Method Attribute

The [TestCase][TestCase] attribute is applied directly to a single test to provide the
parameterized values. There is a clear one to one mapping for each case and
the attributes provided. More options can be configured using named parameters
on the attribute, such as the test name or expected exceptions.

The main drawback of this approach is only simple compile time constants can be
used as parameters. This simplicity is not all bad. It helps keep the cases
focused and avoids having more complicated logic sneak into your test case
setup.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class CaseAttributeStringCalculatorTests {

    [TestCase( "", 0 )]
    [TestCase( "1", 1 )]
    [TestCase( "1,2", 3 )]
    public void Add_SimpleInputs_AddsNumbers( string numbers, int expectedTotal ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

### TestCaseSource Method Attribute

The [TestCaseSource][TestCaseSource] attribute is applied to the test method
like the ``TestCase`` attribute. This method delegates creating parameter values
to other methods, fields or types. Using the ``TestCaseSource`` is more
flexible and can be used to provide more complicated parameter types. Within
the source you can reuse objects/data for multiple tests. Unlike ``TestCase``
multiple tests can use the same ``TestCaseSource``.

In this example, data for each test case is provided using the ``TestCaseData``
type. This type has a fluent interface and properties to configure additional
settings, like the ``TestCase`` attribute. For simple parameters arrays of the
appropriate type or ``object[]`` can be returned instead. Review the
[TestCaseSource][TestCaseSource] documentation for the additional rules.

{% highlight csharp %}
using System.Collections.Generic;
using NUnit.Framework;

[TestFixture]
public class SourceAttributeStringCalculatorTests {

    private static IEnumerable<TestCaseData> AddCases() {
        yield return new TestCaseData( "", 0 );
        yield return new TestCaseData( "1", 1 );
        yield return new TestCaseData( "1,2", 3 );
    }
    
    [Test, TestCaseSource( "AddCases" )]
    public void Add_SimpleInputs_AddsNumbers( string numbers, int expectedTotal ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

### Parameter Attributes

Another option is to apply attributes to the test parameters. They can behave
like ``TestCase`` and ``TestCaseSource`` for a single parameter or form more
complicated test cases.

The following attributes control the values for a parameter:

* [Values][Values]
* [ValueSource][ValueSource]
* [Random][Random]
* [Range][Range]

Whereas the following attributes define how values for multiple parameters are
combined to form test cases:

* [Combinatorial][Combinatorial]
* [Sequential][Sequential]
* [Pairwise][Pairwise]

Clear as mud? That is okay! I have a few examples to help clarify using these
attributes.

## When to use each option

* TestCase for simple tests where you will not want to reuse the cases
* TestCaseSource when there is overlap between cases or you have multiple more complicated parameters
* Parameter Attribute when you want to cover all cases for a value or want to exercise a wider combination of values.

## Conclusions

I hope you enjoyed this overview of the how to create data driven test cases
with NUnit. If you find your tests all look the same, try using test cases to
clean them up.

[nunit]: http://www.nunit.org
[kata]: http://osherove.com/tdd-kata-1/
[TestCase]: http://www.nunit.org/index.php?p=testCase&r=2.6.4
[TestCaseSource]: http://www.nunit.org/index.php?p=testCaseSource&r=2.6.4

[Values]: http://www.nunit.org/index.php?p=values&r=2.6.4
[ValueSource]: http://www.nunit.org/index.php?p=valueSource&r=2.6.4
[Random]: http://www.nunit.org/index.php?p=random&r=2.6.4
[Range]: http://www.nunit.org/index.php?p=range&r=2.6.4
[Combinatorial]: http://www.nunit.org/index.php?p=combinatorial&r=2.6.4
[Sequential]: http://www.nunit.org/index.php?p=sequential&r=2.6.4
[Pairwise]: http://www.nunit.org/index.php?p=pairwise&r=2.6.4