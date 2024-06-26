prettyTable = function(restable, style = 6) {

  if(nrow(restable) == 0)
    return("Nothin to show")

  LRcols = c("LRnolink", "LRlinked", "LRnomut")

  restable |>
    gt(groupname_col = "Pair") |>
    opt_stylize(style = style) |>
    cols_hide(columns = c(Gindex, Gsize, PosCM)) |>
    tab_style(
      style = cell_text(size = pct(95)),
      locations = cells_body(columns = starts_with("Person"))
    ) |>
    tab_style(
      style = cell_text(size = pct(85), weight = "bold", style = "italic"),
      locations = cells_row_groups()
    ) |>
    tab_options(
      row_group.padding = px(1),
      data_row.padding = px(0)
    ) |>
    cols_label(
      LRsingle ~ "LR",
      LRnolink ~ "Unlinked",
      LRlinked ~ "Linked",
      LRnomut  ~ "No mut"
    ) |>
    tab_spanner(
      label = "Combined LR",
      columns = LRcols
    ) |>
    grand_summary_rows(
      columns = LRcols,
      fns = list("Total LR" = ~ prod(.[Gindex == 1])),
      fmt = list(~fmt_scientific(., columns = where(~ is.finite(.x) && .x > 0 && abs(log10(.x)) >= 4),
                                 decimals = 2),
                 ~fmt_number(., columns = where(~ is.finite(.x) && .x > 0 && abs(log10(.x)) < 4),
                             n_sigfig = 4, use_seps = FALSE)),
      missing_text = ""
    ) |>
    fmt_number(c("LRsingle", LRcols), decimals = 3) |>
    tab_style(
      style = cell_fill(color = "greenyellow"),
      locations = cells_grand_summary(columns = LRlinked)
    ) |>
    tab_style(
      style = cell_text(weight = "bold"),
      locations = list(
        cells_column_labels(columns = LRlinked),
        cells_body(columns = LRlinked),
        cells_grand_summary(columns = LRlinked),
        cells_stub_grand_summary()
      )
    ) |>
    # tab_style(
    #   style = cell_text(color = "cyan"), #gray50
    #   locations = cells_body(rows = Gsize == 1)
    # ) |>
    tab_style(
      style = cell_text(size = pct(110)),
      locations = list(cells_grand_summary(), cells_stub_grand_summary())
    ) |>
    sub_missing(missing_text = "") |>
    tab_style(style = cell_fill(color = "azure3"),
              locations = cells_stub(rows = Gsize == 1))
}


prettyMarkerTable = function(mtab) {
  mtab |> gt() |>
    opt_stylize(6) |>
    tab_options(data_row.padding = px(2)) |>
    tab_style(style = cell_text(weight = if(anyNA(mtab$Pair)) 500),
              locations = cells_body(rows = !is.na(Pair))) |>
    sub_missing(missing_text = "") |>
    tab_style(
      style = cell_borders(sides = "left", style = "dashed"),
      locations = cells_body(columns = "Marker")
    ) |>
    tab_style(style = cell_text(whitespace = "nowrap"),
              locations = cells_body()) |>
    tab_spanner(
      label = "Mutation model",
      columns = match("Model", names(mtab)):ncol(mtab)
    )
}

utils::globalVariables(c("PosCM","Gindex","Gsize","LRlinked","LRsingle","Pair"))
