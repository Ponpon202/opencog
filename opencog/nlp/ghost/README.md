# GHOST

GHOST (General Holistic Organism Scripting Tool) is a DSL (Domain-Specific
Language) designed to allow human authors to script behaviors for artificial
characters. GHOST is inspired by ChatScript in its syntax, but it uses OpenPsi
as the engine for topic selection and topic management, as well as various
other OpenCog components for different purposes.

## Design Overview

When one tries to create a rule in GHOST, it will firstly be passed to the
parser (`cs-parser.scm`) for syntax checking and preliminary interpretation.
Any rules that is not syntactically correct will be rejected at this stage.

The parser will then pass the interpretations to the translator (`translator.scm`)
by calling `create-rule`, or other appropriate functions such as `create-concept`
or the like if it is not a rule, and convert each of the interpreted terms into
their corresponding atomese (defined in `terms.scm`). A psi-rule will be created
if the input is a rule (i.e. responder, rejoinder, or gambit).

At this stage, GHOST rule authoring is mostly identical to ChatScript rule authoring.
One has to create topic files and define concepts/rules etc in the appropriate
topic files.

An action selector is defined in `matcher.scm` for rule matching and selection.
When a textual input is received, it will be converted into a list of WordNodes,
wrapped in a `DualLink` and passed to the recognizer in order to find candidates
(i.e. psi-rules) that may satisfy the current context. A full context evaluation
will be done for each of the candidates and the actions of those satisfying ones
will be executed as a result.

## Current Status

For verbal interaction authoring in particular, GHOST syntax is modeled heavily
on [ChatScript](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#rules).
However, GHOST uses several ChatScript features for different purposes than
they are normally used in ChatScript; and also contains some additional features.

Here is a list of features that are fully supported in GHOST:
- [Word/Lemma](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#canonization)
- [Phrase](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#proper-names)
- [Concept](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#concepts)
- [Choice](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#choices--)
- [Indefinite Wildcard](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#simple-indefinite-wildcards-)
- [Precise Wildcard](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#precise-wildcards-n)
- [Range-restricted Wildcard](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#range-restricted-wildcards-n)
- [Variable](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#_-match-variables)
- [User Variable](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#user_variables)
- [Sentence Boundary](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#sentence-boundaries--and-)
- [Negation](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#not--and-notnot-)
- [Function](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Advanced-User-Manual.md#functions)
- [Unordered Matching](https://github.com/bwilcox-1234/ChatScript/blob/master/WIKI/ChatScript-Basic-User-Manual.md#unordered-matching--)


One or more goals can be specified for a rule in this way:

```
#goal: (novelty=0.8 please_user=0.4)
s: ( what be you name ) I forgot; what's YOUR name, sweet wonderful human
```

Topic level goals can also be specified:

```
goal: (please_user=0.5)
```

in which case the specified goals will be applied to every single rule under
the same topic.

Basic examples of how to use GHOST is available [HERE](https://github.com/opencog/opencog/blob/master/examples/ghost/basic.scm)


## How To Run

1) Start the [RelEx server](https://github.com/opencog/relex#opencog-serversh)
2) Start Guile
3) Load the needed modules
```
(use-modules (opencog)
             (opencog nlp relex2logic)
             (opencog openpsi)
             (opencog eva-behavior)
             (opencog nlp ghost))
```
4) Start authoring

A rule can be created by using `ghost-parse`:

```
(ghost-parse "s: (hi robot) Hello human")
```

Similarly for creating concepts:

```
(ghost-parse "concept: ~young (child kid youngster)")
```

One can also load a topic file by using `ghost-parse-file`:

```
(ghost-parse-file "path/to/the/topic/file")
```

5) Play with it

One can quickly test if a rule can be triggered by using `test-ghost`:

```
(test-ghost "hi robot good morning")
```

The output `[INFO] [Ghost] Say: "Hello human"` will be printed.

*Note*: `test-ghost` is mainly for testing and debugging. The
proper way of running it is to start the OpenPsi loop and should use
`ghost` instead of `test-ghost` to send the input.

## To Do

Here is a list of features that are partially working/need to be implemented:

- Speech Acts

A rule starts with:

```
s: is equivalent to declarative or imperative in OpenCog
?: is equivalent to truth query or interrogative in OpenCog
u: means union of the both above
```

- Nested pattern e.g. "you < * [(live * long) long-lived]"

- System functions
  - ^gambit()

- System variables
  - %input

- Rule selection / topic management
  - Gambits
  - Rejoinders
  - Weight the rules by the order of the rules in the topic file
  - Block topic from accidental access, like doing "t: (!~) ^fail(topic)" in ChatScript

- Action orchestrator

- Port all the DefinedPredicateNodes available in chatbot-psi and eva modules
