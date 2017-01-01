Psych Head API
==============

The package include several functions that are distributed along a certain
architecture.

Analysis
--------

This part is related to data analysis and plotting such as psychometric
functions, p50's and Probit analysis.

**ComputePsychFunc**
  Compute the psychometric function for one parameter based on a 2AFC. The
  parameters has to be the first column. The answer on the second column.

.. code-block:: matlab

  [param good_ans_perc] = ComputePsychFunc(data, answer_comp)

**LauraPlot**
  Plot the psychometric function for the intensity experiment.

.. code-block:: matlab

  [figure_handle p50] = LauraPlot(filename)

**ProbitFit**
  Curve fitting using a probit analysis.

.. code-block:: matlab
  
  [fitlogsignal, prob_perc, p50, logsignal, n, p75, p84, chi_sq, rsq, D] = ProbitFit(signal, pcCorrent, numstim)

**ProbitStripped**
  Curve fitting using a probit analysis with a less verbose output.

.. code-block:: matlab
  
  [figure, p50, p75, p84, ch_sq, Rsq, D] = ProbitStripped(signal, pcCorrect, numstim, isPlot, asymptotes)
