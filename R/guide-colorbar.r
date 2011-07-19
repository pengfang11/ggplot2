##' Colorbar type guide
##'
##' Colorbar type guide shows a continuous color scales mapped onto values.
##' Colorbar is available with \code{scale_fill} and \code{scale_colour}.
##' For more information, see \href{http://www.mathworks.com/help/techdoc/ref/colorbar.html}{Matlab site}.
##'
##' Guides can be specified in each scale or in \code{\link{guides}}.
##' \code{guide="legend"} in scale is syntax suger for \code{guide=guide_legend()}.
##' As for how to specify the guide for each scales, see \code{\link{guides}}.
##'
##' @name guide_colorbar
##' @title Colorbar guide
##' @param title A character string or expression indicating a title of guide. If \code{NULL}, the title is not shown. By default (\code{\link{waiver()}}), the name of the scale object or tha name specified in \code{\link{labs}} is used for the title.
##' @param title.position A character string indicating the position of a title. One of "top" (default for a vertical guide), "bottom", "left" (default for a horizontal guide), or "right."
##' @param title.theme A theme object for rendering the title text. Usually the object of \code{\link{theme_text}} is expected. By default, the theme is specified by \code{legend.title} in \code{\link{opts}} or theme.
##' @param label logical. If \code{TRUE} then the labels are drawn. If \code{FALSE} then the labels are invisible.
##' @param label.position A character string indicating the position of a label. One of "top", "bottom" (default for horizontal guide), "left", or "right" (default for vertical gudie).
##' @param label.theme A theme object for rendering the label text. Usually the object of \code{\link{theme_text}} is expected. By default, the theme is specified by \code{legend.text} in \code{\link{opts}} or theme.
##' @param barwidth A numeric or a unit object specifying the width of the colorbar. Default value is \code{legend.key.width} or \code{legend.key.size} in \code{\link{opts}} or theme.
##' @param barheight A numeric or a unit object specifying the height of the colorbar. Default value is \code{legend.key.height} or \code{legend.key.size} in \code{\link{opts}} or theme.
##' @param nbin A numeric specifying the number of bins for drawing colorbar. A smoother colorbar for a larger value.
##' @param raster A logical specifying if the colorbar should be drawn as raster or as vector graphics. Currently, only the raster is supported.
##' @param ticks A logical specifying if tick marks on colorbar should be visible.
##' @param draw.ulim A logical specifying if the upper limit tick marks should be visible.
##' @param draw.llim A logical specifying if the lower limit tick marks should be visible.
##' @param direction  A character string indicating the direction of the guide. One of "horizontal" or "vertical."
##' @param default.unit A character string indicating unit for \code{barwidth} and \code{barheight}. 
##' @param ... ignored.
##' @return Guide object
##' @seealso \code{\link{guides}}, \code{\link{guide_legend}}
##' @export
##' @examples
##' # ggplot objects
##' 
##' p1 <- function()ggplot(melt(outer(1:4, 1:4)), aes(x = X1, y = X2)) + geom_tile(aes(fill = value))
##' p2 <- function()ggplot(melt(outer(1:4, 1:4)), aes(x = X1, y = X2)) + geom_tile(aes(fill = value)) + geom_point(aes(size = value))
##' 
##' 
##' ## basic form
##' 
##' # short version
##' p1() + scale_fill_continuous(guide = "colorbar")
##' 
##' # long version
##' 
##' p1() + scale_fill_continuous(guide = guide_colorbar())
##' 
##' # separately set the direction of each guide
##' p2() + scale_fill_continuous(guide = guide_colorbar(direction = "horizontal")) +
##'   scale_size(guide = guide_legend(direction = "vertical")) ## separately set the direction of each gui
##' 
##' ## control styles
##' 
##' # bar size
##' p1() + scale_fill_continuous(guide = guide_colorbar(barwidth=0.5, barheight=10))
##' 
##' # no label
##' 
##' p1() + scale_fill_continuous(guide = guide_colorbar(label = FALSE))
##' 
##' # no tick marks
##' p1() + scale_fill_continuous(guide = guide_colorbar(ticks = FALSE))
##' 
##' # label position
##' p1() + scale_fill_continuous(guide = guide_colorbar(label.position = "left"))
##' 
##' # small number of bins
##' p1() + scale_fill_continuous(guide = guide_colorbar(nbin = 3))
##' 
##' # large number of bins
##' p1() + scale_fill_continuous(guide = guide_colorbar(nbin = 100))
##' 
##' # make top- and bottom-most ticks invisible
##' p1() + scale_fill_continuous(limits=c(0,20), breaks=c(0,5,10,15,20),
##'                             guide = guide_colorbar(nbin=100, draw.ulim = FALSE, draw.llim = FALSE))
##' 
##' # combine colorbar and legend guide
##' p2() + scale_fill_continuous(guide = "colorbar") + scale_size(guide = "legend")
##' 
##' # same, but short version
##' p2() + guides(fill = "colorbar", size = "legend")
guide_colorbar <- function(
                           
  ##　title
  title = waiver(),
  title.position = NULL,
  title.theme = NULL,

  ## label
  label = TRUE,
  label.position = NULL,
  label.theme = NULL,

  ## bar
  barwidth = NULL,
  barheight = NULL,
  nbin = 20,
  raster = TRUE,

  ## ticks
  ticks = TRUE,
  draw.ulim= TRUE,
  draw.llim = TRUE,

  ## general
  direction = NULL,
  default.unit = "line",
                          
  ...) {
  
  if (!is.null(barwidth) && !is.unit(barwidth)) barwidth <- unit(barwidth, default.unit)
  if (!is.null(barheight) && !is.unit(barheight)) barheight <- unit(barheight, default.unit)

  structure(list(
    ##　title
    title = title,
    title.position = title.position,
    title.theme = title.theme,

    ## label
    label = label,
    label.position = label.position,
    label.theme = label.theme,

    ## bar
    barwidth = barwidth,
    barheight = barheight,
    nbin = nbin,
    raster = raster,

    ## ticks
    ticks = ticks,
    draw.ulim = draw.ulim,
    draw.llim = draw.llim,

    ## general
    direction = direction,
    default.unit = default.unit,
                 
    ## parameter
    available_aes = c("colour", "color", "fill"),
                 
    ..., name="colorbar"),
    class=c("guide", "colorbar"))
}

guide_train.colorbar <- function(guide, scale) {

  ## do nothing if scale are inappropriate
  if (length(intersect(scale$aesthetics, c("color", "colour", "fill"))) == 0) {
    warning("colorbar guide needs colour or fill scales.")
    return(NULL)
  }
  if (!inherits(scale, "continuous")) {
    warning("colorbar guide needs continuous scales.")
    return(NULL)
  }
  
  
  ## ticks - label (i.e. breaks)
  output <- scale$aesthetics[1]
  breaks <- scale_breaks(scale)
  guide$key <- data.frame(scale_map(scale, breaks), I(scale_labels(scale, breaks)), breaks,
                          stringsAsFactors = FALSE)
  
  ## .value = breaks (numeric) is used for determining the position of ticks in gengrob
  names(guide$key) <- c(output, ".label", ".value")

  ## bar specification (number of divs etc)
  .bar <- discard(pretty(scale_limits(scale), n = guide$nbin), scale_limits(scale))
  guide$bar <- data.frame(colour=scale_map(scale, .bar), value=.bar, stringsAsFactors = FALSE)
  guide$hash <- with(guide, digest(list(title, key$.label, bar, name)))
  guide
}

## simply discards the new guide
guide_merge.colorbar <- function(guide, new_guide) {
  guide
}

## this guide is not geom-based.
guide_geom.colorbar <- function(guide, ...) {
  guide
}

guide_gengrob.colorbar <- function(guide, theme) {

  ## settings of location and size
  switch(guide$direction,
    "horizontal" = {
      label.position <- guide$label.position %||% "bottom"
      if (!label.position %in% c("top", "bottom")) stop("label position \"", label.position, "\" is invalid")
  
      barwidth <- convertWidth(guide$barwidth %||% (theme$legend.key.width * 5), "mm")
      barheight <- convertHeight(guide$barheight %||% theme$legend.key.height, "mm")
    },
    "vertical" = {
      label.position <- guide$label.position %||% "right"
      if (!label.position %in% c("left", "right")) stop("label position \"", label.position, "\" is invalid")
      
      barwidth <- convertWidth(guide$barwidth %||% theme$legend.key.width, "mm")
      barheight <- convertHeight(guide$barheight %||% (theme$legend.key.height * 5), "mm")
    })
         
  barwidth.c <- c(barwidth)
  barheight.c <- c(barheight)
  barlength.c <- switch(guide$direction, "horizontal" = barwidth.c, "vertical" = barheight.c)
  nbreak <- nrow(guide$key)
  
  ## gap between keys etc
  hgap <- c(convertWidth(unit(0.3, "lines"), "mm"))
  vgap <- hgap
  
  if (guide$raster) {
    image <- switch(guide$direction, "horizontal" = t(guide$bar$colour), "vertical" = guide$bar$colour)
    grob.bar <- rasterGrob(image = image, width=barwidth.c, height=barheight.c, default.units = "mm", gp=gpar(col=NA), interpolate = TRUE)
  }

  ## tick and label position
  tic_pos.c <- rescale(guide$key$.value, c(0.5, guide$nbin-0.5), range(guide$bar$value)) * barlength.c / guide$nbin
  label_pos <- unit(tic_pos.c, "mm")
  if (!guide$draw.ulim) tic_pos.c <- tic_pos.c[-1]
  if (!guide$draw.llim) tic_pos.c <- tic_pos.c[-length(tic_pos.c)]

  ## title
  ## hjust of title should depend on title.position
  title.theme <- guide$title.theme %||% theme$legend.title
  grob.title <- {
    if (is.null(guide$title))
      zeroGrob()
    else
      title.theme(label=guide$title, name=grobName(NULL, "guide.title"))
  }

  title_width <- convertWidth(grobWidth(grob.title), "mm")
  title_width.c <- c(title_width)
  title_height <- convertHeight(grobHeight(grob.title), "mm")
  title_height.c <- c(title_height)

  ## label
  label.theme <- guide$label.theme %||% theme$legend.text
  grob.label <- {
    if (!guide$label)
      zeroGrob()
    else
      switch(guide$direction, horizontal = {x <- label_pos; y <- 0.5}, "vertical" = {x <- 0.5; y <- label_pos})
      label.theme(label=guide$key$.label, x = x, y = y, name = grobName(NULL, "guide.label"))
  }

  label_width <- convertWidth(grobWidth(grob.label), "mm")
  label_width.c <- c(label_width)
  label_height <- convertHeight(grobHeight(grob.label), "mm")
  label_height.c <- c(label_height)

  ## ticks
  grob.ticks <-
    if (!guide$ticks) zeroGrob()
    else {
      switch(guide$direction,
        "horizontal" = {
          x0 = rep(tic_pos.c, 2)
          y0 = c(rep(0, nbreak), rep(barheight.c * (4/5), nbreak))
          x1 = rep(tic_pos.c, 2)
          y1 = c(rep(barheight.c * (1/5), nbreak), rep(barheight.c, nbreak))
        },
        "vertical" = {
          x0 = c(rep(0, nbreak), rep(barwidth.c * (4/5), nbreak))
          y0 = rep(tic_pos.c, 2)
          x1 = c(rep(barwidth.c * (1/5), nbreak), rep(barwidth.c, nbreak))
          y1 = rep(tic_pos.c, 2)
        })
      segmentsGrob(x0 = x0, y0 = y0, x1 = x1, y1 = y1,
                   default.units = "mm", gp = gpar(col="white", lwd=0.5, lineend="butt"))
    }

  ## layout of bar and label
  switch(guide$direction,
    "horizontal" = {
      switch(label.position,
        "top" = {
          bl_widths <- barwidth.c
          bl_heights <- c(label_height.c, vgap, barheight.c)
          vps <- list(bar.row = 3, bar.col = 1,
                      label.row = 1, label.col = 1)
        },
        "bottom" = {
          bl_widths <- barwidth.c
          bl_heights <- c(barheight.c, vgap, label_height.c)
          vps <- list(bar.row = 1, bar.col = 1,
                      label.row = 3, label.col = 1)
        })
    },
    "vertical" = {
      switch(label.position,
        "left" = {
          bl_widths <- c(label_width.c, vgap, barwidth.c)
          bl_heights <- barheight.c
          vps <- list(bar.row = 1, bar.col = 3,
                      label.row = 1, label.col = 1)
        },
        "right" = {
          bl_widths <- c(barwidth.c, vgap, label_width.c)
          bl_heights <- barheight.c
          vps <- list(bar.row = 1, bar.col = 1,
                      label.row = 1, label.col = 3)
        })
    })

  ## layout of title and bar+label
  switch(guide$title.position,
    "top" = {
      widths <- c(bl_widths, max(0, title_width.c-sum(bl_widths)))
      heights <- c(title_height.c, vgap, bl_heights)
      vps <- with(vps,
                  list(bar.row = bar.row+2, bar.col = bar.col,
                       label.row = label.row+2, label.col = label.col,
                       title.row = 1, title.col = 1:length(widths)))
    },
    "bottom" = {
      widths <- c(bl_widths, max(0, title_width.c-sum(bl_widths)))
      heights <- c(bl_heights, vgap, title_height.c)
      vps <- with(vps, 
                  list(bar.row = bar.row, bar.col = bar.col,
                       label.row = label.row, label.col = label.col,
                       title.row = length(heights), title.col = 1:length(widths)))
    },
    "left" = {
      widths <- c(title_width.c, hgap, bl_widths)
      heights <- c(bl_heights, max(0, title_height.c-sum(bl_heights)))
      vps <- with(vps, 
                  list(bar.row = bar.row, bar.col = bar.col+2,
                       label.row = label.row, label.col = label.col+2,
                       title.row = 1:length(heights), title.col = 1))
    },
    "right" = {
      widths <- c(bl_widths, hgap, title_width.c)
      heights <- c(bl_heights, max(0, title_height.c-sum(bl_heights)))
      vps <- with(vps, 
                  list(bar.row = bar.row, bar.col = bar.col,
                       label.row = label.row, label.col = label.col,
                       title.row = 1:length(heights), title.col = length(widths)))
    })

  ## background
  grob.background <- theme_render(theme, "legend.background")

  lay <- data.frame(l = c(1, min(vps$bar.col), min(vps$label.col), min(vps$title.col), min(vps$bar.col)),
                    t = c(1, min(vps$bar.row), min(vps$label.row), min(vps$title.row), min(vps$bar.row)),
                    r = c(length(widths), max(vps$bar.col), max(vps$label.col), max(vps$title.col), max(vps$bar.col)),
                    b = c(length(heights), max(vps$bar.row), max(vps$label.row), max(vps$title.row), max(vps$bar.row)),
                    name = c("background", "bar", "label", "title", "ticks"),
                    clip = FALSE)

  gtable(list(grob.background, grob.bar, grob.label, grob.title, grob.ticks), lay, unit(widths, "mm"), unit(heights, "mm"))
}
