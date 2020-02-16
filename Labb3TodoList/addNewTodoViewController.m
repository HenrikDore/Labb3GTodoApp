//
//  addNewTodoViewController.m
//  Labb3TodoList
//
//  Created by Henrik Doré on 2020-01-20.
//  Copyright © 2020 Henrik Doré. All rights reserved.
//

#import "addNewTodoViewController.h"
#import "ViewController.h"

@interface addNewTodoViewController ()
@property (nonatomic, strong) NSMutableArray *todoArray;

@property (weak, nonatomic) IBOutlet UITextField *NewTodoTxt;
@property (weak, nonatomic) IBOutlet UILabel *todoAddedLabel;
@end

@implementation addNewTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)AddNewTodoBtn:(id)sender {
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _todoArray = [[defaults objectForKey:@"todoarrayKey"] mutableCopy];
       
    if(self.todoArray == nil){
        _todoArray = [[NSMutableArray alloc] init];
    }
      
    [_todoArray addObject: _NewTodoTxt.text];
          
    [defaults setObject:_todoArray forKey:@"todoarrayKey"];
    [defaults synchronize];
    self.todoAddedLabel.text = @"Todo Added";
    _NewTodoTxt.text = @"";
      
}

@end
