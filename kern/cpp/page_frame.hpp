#pragma once

struct PageFrame
{
  explicit PageFrame(PageFrame *next = nullptr,
                     PageFrame *next_free = nullptr)
  : next(next),
    next_free(next_free)
  {}

  PageFrame *next;
  PageFrame *next_free;
};
