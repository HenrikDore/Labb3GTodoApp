//
//  ViewController.m
//  Labb3TodoList
//
//  Created by Henrik Doré on 2020-01-20.
//  Copyright © 2020 Henrik Doré. All rights reserved.
//

#import "ViewController.h"
#import "addNewTodoViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *todolistArrayNewFromUser;
@property (strong, nonatomic) NSMutableArray *doneTodoArray;
@property (strong, nonatomic) NSMutableArray *sections;
@end

@implementation ViewController


@synthesize todoListArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sections = [[NSMutableArray alloc] init];
    
    [_sections addObject:@"Pågående"];
    [_sections addObject:@"Färdiga"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


-(void)viewDidAppear:(BOOL)animated{
    [self getUserDefaults];
    [_tableView reloadData];
    
}

-(void)getUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _todolistArrayNewFromUser = [[defaults objectForKey:@"todoarrayKey"] mutableCopy];
    _doneTodoArray = [[defaults objectForKey:@"doneArrayKey"] mutableCopy];
    
    if(_todolistArrayNewFromUser == nil){
        _todolistArrayNewFromUser = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"%@", _todolistArrayNewFromUser);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [_todolistArrayNewFromUser count];
    }
    else{
        return [_doneTodoArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if(indexPath.section == 0){
        cell.textLabel.text = (_todolistArrayNewFromUser[indexPath.row]);
        cell.backgroundColor = [UIColor whiteColor];
    }
    else{
        cell.textLabel.text = (_doneTodoArray[indexPath.row]);
        cell.backgroundColor = [UIColor redColor];
    }
        
    return cell;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        if(indexPath.section == 0){
            [_todolistArrayNewFromUser removeObjectAtIndex:indexPath.row];
            [self saveDataInUserDefaults];
            [self.tableView reloadData];
        }
        else{
            [_doneTodoArray removeObjectAtIndex:indexPath.row];
            [self saveDataInUserDefaults];
            [self.tableView reloadData];
        }
           
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Färdig?" message:@"Flytta raden till färdig" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Markera som klar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if(self.doneTodoArray == nil){
                self.doneTodoArray = [[NSMutableArray alloc] init];
            }
            
            NSString *x = [self.todolistArrayNewFromUser objectAtIndex:indexPath.row];
            
            [self.todolistArrayNewFromUser removeObjectAtIndex:indexPath.row];
            
            [self->_doneTodoArray addObject:x];
            
            [self saveDataInUserDefaults];
            
            [self.tableView reloadData];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Avbryt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alertVc addAction:done];
        [alertVc addAction:cancel];
        
        [self presentViewController:alertVc animated:true completion:nil];
    }
}

- (void) saveDataInUserDefaults{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:self->_todolistArrayNewFromUser forKey:@"todoarrayKey"];
     [defaults setObject:self->_doneTodoArray forKey:@"doneArrayKey"];
     [defaults synchronize];
}

- (IBAction)newtodoBtn:(id)sender {
}

@end
