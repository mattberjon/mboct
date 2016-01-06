function [] = ExportTikz(filename, fig_id)

  if IsOctave()
    print dtikz filename.tikz fig_id
  else

  end
end
