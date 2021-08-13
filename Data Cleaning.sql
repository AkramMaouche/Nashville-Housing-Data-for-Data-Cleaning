Select * 
From PortfolioProject.dbo.NashvilleHousing


-- Standrdize Data Format 

Select SaleDate 
From NashvilleHousing

Alter Table NashvilleHousing 
Add SaleDataConverted Date 

Update NashvilleHousing 
Set SaleDataConverted = Convert(Date ,SaleDate)

Alter Table NashvilleHousing 
Drop Column SaleDate

--Populate Property Adress Data


Select Nash_1.ParcelID , Nash_1.PropertyAddress, Nash_2.ParcelID,Nash_2.PropertyAddress,
ISNULL(Nash_1.PropertyAddress,Nash_2.PropertyAddress) As PrAdr
From NashvilleHousing as Nash_1
Join NashvilleHousing as Nash_2 
    On Nash_1.ParcelID = Nash_2.ParcelID
	AND Nash_1.[UniqueID ] <> Nash_2.[UniqueID ]
Where Nash_1.PropertyAddress is Null 

Update Nash_1
Set PropertyAddress = ISNULL(Nash_1.PropertyAddress,Nash_2.PropertyAddress) 
From NashvilleHousing as Nash_1
Join NashvilleHousing as Nash_2 
    On Nash_1.ParcelID = Nash_2.ParcelID
	AND Nash_1.[UniqueID ] <> Nash_2.[UniqueID ]
Where Nash_1.PropertyAddress is Null 

--- Breakingout Propertyadress into individual columns (Adress ,city,state ) SplitePropty adress -----

Select PropertyAddress
From NashvilleHousing

Select
Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as SplitProprtyAdress ,
Substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as SplitProprtyCity 
From NashvilleHousing

Alter Table NashvilleHousing
Add SplitProprtyAdress Nvarchar(255) 
Update NashvilleHousing 
Set SplitProprtyAdress = Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) 

Alter Table NashvilleHousing
Add SplitProprtyCity Nvarchar(255) 
Update NashvilleHousing 
Set SplitProprtyCity =  Substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))

--------Split Owner Adress -----------
Select OwnerAddress
From NashvilleHousing 

Select
PARSENAME(OwnerAddress,1)
From NashvilleHousing -- Nothing happen cuz Parsname work with '.'

Select
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
From NashvilleHousing

Alter Table NashvilleHousing
Add SplitOwnerAddress nvarchar(255),
    SplitOwnerCity nvarchar(255),
    SplitOwnerState nvarchar(255) 

Update NashvilleHousing 
Set SplitOwnerAddress =  PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
    SplitOwnerCity  =  PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
	SplitOwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


----- change Y and no to yes are no in sold facant field 
Select Distinct SoldAsVacant , COUNT(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant

Select SoldAsVacant,
Case  When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant 
      End 
From NashvilleHousing

Update NashvilleHousing 
Set SoldAsVacant = Case  When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant 
      End 
From NashvilleHousing



