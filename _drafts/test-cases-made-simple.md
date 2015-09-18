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

[TestFixture]
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

We can do better. Thankfully NUnit allows you to create
[parameterized][parameterized] tests using a number of test case attributes.
Using the attributes we can dramatically reduce the duplicate code in the
tests. You can do so by refactoring your test and introducing parameters. Then
using the attributes we can provide the test with whatever data we need for our
test cases. Our newly refactored method might look something like this before
we add any of the test case attributes.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class RefactoredStringCalculatorTests {

    // Warning: This will not run in its current state.
    //          You need to add the attributes first!
    [Test]
    public void Add_SimpleInputs_AddsNumbers( string numbers, int expectedTotal ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

### TestCase Method Attribute

The [TestCase][TestCase] attribute is applied directly to a single test to
provide the parameterized values. The values in the parameter result provide a
single test case. If you want multiple cases add more attributes! The values
provided to the TestCase attribute line up with their matching parameter. More
options can be configured using named parameters on the attribute, such as the
test name or expected exceptions.

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
the source you can reuse objects/data for multiple tests so multiple cases can
use a mixture of the same values. Another benefit is multiple tests case use
the same how ``TestCaseSource`` unlike ``TestCase`` which is only applied to
one test at at time.

The type of data provided to the test is very flexible.  For simple parameters
arrays of the appropriate type or ``object[]`` with nested arrays can be
returned from the method. I prefer using ``IEnumerable<TestCaseData>`` which
has extra attributes like ``TestCase`` for configuring the test. ``TestCaseData`` Review the
[TestCaseSource][TestCaseSource] documentation for the additional rules.

To use ``TestCaseSource`` you provide a ``sourceName`` and/or ``sourceType``.
If only ``sourceName`` is used the field/method is assumed to be in the same
test fixture as the test. In this example we provide a ``sourceName`` referring to the ``"AddCases"``
method which returns ``IEnumerable<TestCaseData>``.

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

The following attributes are placed on a parameter and control the parameter's values:

* [Values][Values]
* [ValueSource][ValueSource]
* [Random][Random]
* [Range][Range]

Whereas the following attributes are applied to the method and define how values
for multiple parameters are combined to form test cases:

* [Combinatorial][Combinatorial]
* [Sequential][Sequential]
* [Pairwise][Pairwise]

Clear as mud? That is okay! I have a few examples to help clarify using these
attributes.

This simple example shows using the ``Values`` attribute inline with a single
parameter. The values from the attribute each create a single test case to be
executed. This behaves like ``TestCase`` for a single parameter.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class ValuesAttributeStringCalculatorTests {

    [Test]
    public void Add_NullOrBlank_ReturnsZero(
        [Values( null, "", " ", "\t", "\n" )] string input
    ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( input );

        Assert.AreEqual( 0, total );
    }
}
{% endhighlight %}

The ``ValueSource`` provides values from a method, or field or type. Just how
``Values`` behaves like ``TestCase``, ``ValueSource`` behaves like
``TestCaseSource``.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class ValuesAttributeStringCalculatorTests {

    private static string[] NullOrBlankCases = new string[] {
        null,
        "",
        " ",
        "\t",
        "\n"
    };

    [Test]
    public void Add_NullOrBlank_ReturnsZero(
        [ValueSource( "NullOrBlankCases" )] string input
    ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( input );

        Assert.AreEqual( 0, total );
    }
}
{% endhighlight %}

``Range`` and ``Random`` are two special cases for specifying numbers.

``Range`` generates test cases between a starting point, an end point and
optionally the step size between each test case. In the example below, I use
``Range`` starting at 2 and going to 10 in steps of 2 to produce cases using
2, 4, 6, 8, 10.

``Random`` generates a number of test cases using random numbers, optionally
between between two values. The example below generates a random number between
0 and 10 for 5 test cases.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class ValuesAttributeStringCalculatorTests {

    [Test]
    public void Add_EvenNumbersBetweenTwoAndTen_ReturnsTheNumber(
        [Range( 2, 10, 2 )] int number
    ) {
        StringCalculator calculator = new StringCalculator();

        string numbers = number.ToString();
        int total = calculator.Add( numbers );

        Assert.AreEqual( number, total );
    }

    [Test]
    public void Add_RandomNumberBetweenZeroAndTen_ReturnsTheNumber(
        [Random( 0, 10, 5 )] int number
    ) {
        StringCalculator calculator = new StringCalculator();

        string numbers = number.ToString();
        int total = calculator.Add( numbers );

        Assert.AreEqual( number, total );
    }
}
{% endhighlight %}

Cool! Dealing with a single parameter is really easy. How does it work with
multiple parameters? This is where the other attributes are used to control the
behaviour for combining values for all the parameters. They are placed on the
method and are mutually exclusive.

The default behaviour is to evaluate possible cases caused by the parameters.
You can specify this behaviour explicitly using the ``Combinatorial`` attribute
on the method.

Another option is to treat the input to each parameter as a sequence. Imagine
lining up each parameter value then treating the result as a test case. This is
how the ``Sequential`` attribute works. It can be a little awkward to mentally
determine what the cases will be. I try to use this option sparingly. The
example below uses the attribute to create three test cases:

* "", 0
* "1", 1
* "1,2", 3

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class ParameterAttributeStringCalculatorTests {

    private static string[] TestNumbers() {
        return new string[] {
            "",
            "1",
            "1,2"
        };
    }

    private static int[] TestTotals() {
        return new int[] {
            0,
            1,
            3
        };
    }

    [Test, Sequential]
    public void Add_SimpleInputs_AddsNumbers(
        [ValueSource( "TestNumbers" )] string numbers,
        [ValueSource( "TestTotals" )] int expectedTotal
    ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

The last attribute to modify how that parameters are combined is ``Pairwise``.
It uses a heuristic to create cases covering every possible pair of parameters.
This is intended to generate fewer cases than ``Combinatorial`` while still
providing a good mix of cases. I have not used it on a project before. If you
have too many tests caused by combinatorial cases you may want to try using this.

## Go Test, With Cases!

I hope you enjoyed this overview of the how to create test cases with NUnit. To
make it easy to worth through the examples I have uploaded a [repository][repo] to
github with each of the examples. I even included a few bonus examples I made
along the way. Enjoy.

If you find your tests all look the same, try using test cases to clean them up.

[nunit]: http://www.nunit.org
[kata]: http://osherove.com/tdd-kata-1/
[parameterized]: http://www.nunit.org/index.php?p=parameterizedTests&r=2.5.10
[TestCase]: http://www.nunit.org/index.php?p=testCase&r=2.6.4
[TestCaseSource]: http://www.nunit.org/index.php?p=testCaseSource&r=2.6.4
[Values]: http://www.nunit.org/index.php?p=values&r=2.6.4
[ValueSource]: http://www.nunit.org/index.php?p=valueSource&r=2.6.4
[Random]: http://www.nunit.org/index.php?p=random&r=2.6.4
[Range]: http://www.nunit.org/index.php?p=range&r=2.6.4
[Combinatorial]: http://www.nunit.org/index.php?p=combinatorial&r=2.6.4
[Sequential]: http://www.nunit.org/index.php?p=sequential&r=2.6.4
[Pairwise]: http://www.nunit.org/index.php?p=pairwise&r=2.6.4
[repo]: https://github.com/smaclell/nunit-testcase-examples
