function [file_ids] = GetFileIDs (path_name, pattern)

 dirname = dir ([path_name '/*.mat']);
 files_nb = length (dirname);

 id = 1;
 for a = 1:files_nb
    pattern_match = regexpi(dirname(a).name, pattern, 'match');
    
    if ~isempty (pattern_match)
      file_ids(id) = a;
      id = id + 1;
    end
  end
end
