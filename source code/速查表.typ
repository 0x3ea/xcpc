
$ mat(
    cos theta, -sin theta;
    sin theta, cos theta;  
) $

#set math.mat(delim: "[")
$ mat(
  1, 2, ..., 10;
  2, 2, ..., 10;
  dots.v, dots.v, dots.down, dots.v;
  10, 10, ..., 10;
) $

#table(
  columns: (1fr, 1fr),
  rows: (30pt, 30pt),
  align: center,
  inset: 10pt,
  [theta], [$theta$],
  [equiv], [$equiv$],
  [in.not], [$in.not$],
  [plus.circle], [$plus.circle$],
  [phi], [$phi$],
  [amp],[$amp$],
  [pi],[$pi$],
  [arrow(a)],[$arrow(a)$],
  [times],[$times$],
  [0 degree],[$0 degree$],
  [ceil(x/2) ],[$ceil(x/2) $],
  [floor(x/2) ],[$floor(x/2) $],
  [abs(x/2) ],[$abs(x/2) $],
  [alpha],[$alpha$],
  [beta],[$beta$],
  [\<->],[$<->$]

)

