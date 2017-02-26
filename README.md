# Psych Head

This project has been developed within the Action and Perception group of the
school of Psychology at Cardiff University. A new audiovisual lab has been
created and needed a bit of code in order to be analyse the data provided by
the measurements and simulations. [Octave][l1] has been chosen for several
reasons:

* Open source software
* Good compatibility with Matlab (used inside the Lab)
* Good toolboxes for signal processing

Please, download it, study it, improve it and share it!

## Installation

You have two choices, or you create a copy of repo and add the content to your
patch such as the following:

Copy the files in your home folder `~/` and edit the `~/Octave` file by adding
the following line:

```console
addpath('<directory/where/are/stored/the/files>')
```

You can as well download the [lastest release][l5] and install it using the
`pkg` command:

```console
$ pkg install somewhere/pkgname-x.y.z.tar.gz
```

## License

Please refer to the LICENSE file at the root of the project.

## Contributing

We’re really happy to accept contributions from the community, that’s the main
reason why we open-sourced it! There are many ways to contribute, even if
you’re not a technical person.

We’re using the infamous [simplified Github workflow][l2] to accept
modifications (even internally), basically you’ll have to:

* create an issue related to the problem you want to fix (good for traceability
  and cross-reference)
* fork the repository
* create a branch (optionally with the reference to the issue in the name)
* hack hack hack
* commit incrementally with readable and detailed commit messages
* submit a pull-request against the master branch of this repository

We’ll take care of tagging your issue with the appropriated labels and answer
within a week (hopefully less!) to the problem you encounter.

If you’re not familiar with open-source workflows or our set of technologies,
do not hesitate to ask for help! We can mentor you or propose good first bugs
(as labeled in our issues). Also welcome to add your name to Credits section of
this document.

### Submitting bugs

You can report issues the issue tracker of the [project][l4], that would be a
really useful contribution given that we lack some user testing on the project.
Please document as much as possible the steps to reproduce your problem 
(even better with screenshots).


## Credits

* [Matthieu Berjon][1]
* All the contributors of Pure Data



[l1]: https://www.gnu.org/software/octave/
[l2]: http://scottchacon.com/2011/08/31/github-flow.html
[l4]: https://github.com/mattberjon/psych-head/issues
[l5]: https://github.com/mattberjon/psych-head/tarball/master
