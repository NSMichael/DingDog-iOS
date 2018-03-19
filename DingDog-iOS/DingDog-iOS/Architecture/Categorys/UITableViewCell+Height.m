//
//  UITableViewCell+Height.m
//  ZhaoBu
//
//  Created by 耿功发 on 15/8/7.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "UITableViewCell+Height.h"

@implementation UITableViewCell (Height)

/**
 下面是公用方法，可以放到UITableViewCell的category中
 */
- (CGFloat)calculateCellHeightInAutolayoutMode:(UITableViewCell*)cellRef tableView:(UITableView*)tableView{
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cellRef setNeedsUpdateConstraints];
    [cellRef updateConstraintsIfNeeded];
    
    // Set the width of the cell to match the width of the table view. This is important so that we'll get the
    // correct height for different table view widths, since our cell's height depends on its width due to
    // the multi-line UILabel word wrapping. Don't need to do this above in -[tableView:cellForRowAtIndexPath]
    // because it happens automatically when the cell is used in the table view.
    cellRef.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cellRef.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cellRef setNeedsLayout];
    [cellRef layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cellRef.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for internal rounding errors that are occasionally observed in
    // the Auto Layout engine, which cause the returned height to be slightly too small in some cases.
    height += 1;
    
    return height;
}

@end
