--- 
layout: post
title:  'Adding Epicycles: Copernicus On Software&nbsp;Development'
date:   2008-07-20
--- 

Most software projects suffer from increasing complexity over their lifetime.
One of the most common ways that a project grows in complexity is known as
"Adding Epicycles".

<!--more-->

The geocentric model of the solar system is a very old one. First postulated by
Plato and Aristotle in the 6th century BC, the idea that the Earth is at the
center of the universe was later refined and standardized in Claudius Ptolemy's
main astronomical book, Almagest. It is also an excellent example of a very
common design failure in software development.

## Ptolemy's Faulty Assumption

It seems like a pretty obvious idea: sun, stars, planets&hellip; everything
*looks* as if it goes around the Earth. Indeed, it was almost two thousand
years before Copernicus was able to provide a convincing alternative.

## Ptolemy's Great Design Failure

As people began to make better and better observations of the motions of the
various heavenly bodies, they began to notice that their movements were often
far more complex than the Ptolemaic system could allow. The planets were
particularly troublesome in this regard.

The logical step when a hypothesis no longer fits with observation is to
reconsider that hypothesis and possibly discard it in place of a more fitting
candidate. This is precisely what did not happen when Ptolemy set out to
catalog the arrangements and movements of the celestial spheres.

What he did instead was add smaller circles that the planets move in, and then
have these circles move on top of their orbital circles. These circles on top
of circles - or *epicycles* - form the basis of Ptolemy's new and "improved"
geocentric model.

Ptolemy's greatest mistake was not made in adopting the geocentric model in the
first place. It was made in not abandoning it when it no longer fit observed
fact. Rather than throw out his bad design, he added more and more layers of
bad design to try to fit the new observations.

## Copernicus's Great Refactor

This process of adding more and more complexity onto complexity continued
through iteration after iteration for almost two thousand years until
Copernicus stepped in. He fixed the bad design at the root of the ridiculously
complex and unwieldy Ptolemaic system by putting the Sun at the center. This
simple change had a profoundly simplifying effect on our understanding of the
motion of the planets and other heavenly bodies.

Copernicus's heliocentric model is in retrospect a rather simple and obvious
paradigm shift. Nevertheless, it marked the start of the Scientific Revolution
and is often regarded as the starting point of modern astronomy.

## Copernicus on Software Development

What does all of this mean for software developers? It means that if your
system is built on a bad design, trying to accomodate that problem will only
lead you to add more and more levels of bad design. Eventually the whole system
will come crashing down under the weight of this accumulated technical debt.

This process of iteratively adding layers of complexity and bad design to
attempt to shore up a faulty assumption or hopelessly flawed abstraction is
called [Adding Epicycles](http://c2.com/cgi/wiki?AddingEpicycles) in honor of
Ptolemy and his great design failure. The right thing to do is to follow
Copernicus's lead and correct the faulty assumption or poor abstraction that is
at the heart of your design failure. The sooner you do this, the sooner you can
start simplifying your code.

Correcting a critical design flaw will often cause these layers of circle upon
circle upon preposterous circle of complexty to vanish, leaving your code clean
and clear and simple. Just try not to anger the Pope.
