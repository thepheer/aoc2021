macro_rules! combinations {
  ($items:ident $($idents:ident)+) => {{
    let $items = &$items;
    combinations!($items ($($idents)+) ())
  }};
  ($items:ident ($first:ident $($rest:ident)+) ($($acc:ident)*)) => {
    $items.iter().enumerate().flat_map(move |(i, $first)| {
      let $items = &$items[1 + i..];
      combinations!($items ($($rest)+) ($($acc)* $first))
    })
  };
  ($items:ident ($last:ident) ($($acc:ident)*)) => {
    $items.iter().map(move |$last| ($($acc,)* $last))
  };
}
