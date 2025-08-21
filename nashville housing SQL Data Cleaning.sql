SELECT * 
FROM portfolioproject.`nashville housing data for data cleaning`;

SELECT count(distinct UniqueID)
FROM portfolioproject.`nashville housing data for data cleaning`;

/*
Cleaning data in SQL queries
*/
-----------------------------------------------------------------
-- Standardize date format
SELECT SaleDate, date_format('SaleDate', '%Y, %m, %d') as YearDate
FROM portfolioproject.`nashville housing data for data cleaning`;

------------------------------------------------------------------
-- populate property Address data
SELECT *
FROM portfolioproject.`nashville housing data for data cleaning`
order by parcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
FROM portfolioproject.`nashville housing data for data cleaning` a
join portfolioproject.`nashville housing data for data cleaning` b
on a.PropertyAddress = b.PropertyAddress
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 FROM portfolioproject.`nashville housing data for data cleaning` a
 join portfolioproject.`nashville housing data for data cleaning` b
	on a.PropertyAddress = b.PropertyAddress
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null; 

-----------------------------------------------------------------
-- Breaking out Address into individual columns (Address, City, State)
SELECT PropertyAddress
FROM portfolioproject.`nashville housing data for data cleaning`
order by parcelID;

SELECT PropertyAddress,
substring_index(PropertyAddress, ',', 1) as Address1
-- substring_index(PropertyAddress, ',', -1) as Address2
FROM portfolioproject.`nashville housing data for data cleaning`;

alter table `nashville housing data for data cleaning`
add PropertySplitAddress text;

alter table `nashville housing data for data cleaning`
add PropertySplitCity text;

update `nashville housing data for data cleaning`
set PropertySplitAddress = substring_index(PropertyAddress, ',', 1);

update `nashville housing data for data cleaning`
set PropertySplitCity = substring_index(PropertyAddress, ',', -1);

SELECT OwnerAddress,
substring_index(OwnerAddress, ',',1) as address1, substring_index(OwnerAddress, ',',2) as address2,
substring_index(OwnerAddress, ',', -1) as address3
FROM portfolioproject.`nashville housing data for data cleaning`;

SELECT OwnerAddress,
substring_index(OwnerAddress, ',', 1) as Address1,
substring_index(substring_index(OwnerAddress, ',',-2), ',',1) as Address2,
substring_index(OwnerAddress, ',', -1)  as Address3
FROM portfolioproject.`nashville housing data for data cleaning`;

alter table `nashville housing data for data cleaning`
add OwnerSplitAddress text;

alter table `nashville housing data for data cleaning`
add OwnerSplitCity text;

alter table `nashville housing data for data cleaning`
add OwnerSplitState text;

update `nashville housing data for data cleaning`
set OwnerSplitAddress = substring_index(OwnerAddress, ',', 1);

update `nashville housing data for data cleaning`
set OwnerSplitCity = substring_index(substring_index(OwnerAddress, ',',-2), ',',1);

update `nashville housing data for data cleaning`
set OwnerSplitState = substring_index(OwnerAddress, ',', -1);

------------------------------------------------------------------
-- change Y and N to Yes and No in "Sold as Vacant" filed

select distinct(SoldAsVacant), count(SoldAsVacant)
FROM portfolioproject.`nashville housing data for data cleaning`
group by 1
order by 2;
 
select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
     end
FROM portfolioproject.`nashville housing data for data cleaning`;

update `nashville housing data for data cleaning`
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
     end;

---------------------------------------------------------------------
-- Remove Duplicate
with RowNumCte as (
SELECT *,
	row_number() over (
    partition by ParcelID,
				PropertyAddress,
				SalePrice,
                SaleDate,
				LegalReference
                order by 
                UniqueID
                ) row_num
FROM portfolioproject.`nashville housing data for data cleaning`
order by ParcelID
)
delete
from RowNumCte
where row_num > 1
order by PropertyAddress;


-- Temporary table

----------------------------------------------------------------
-- Remove unused column

select *
FROM portfolioproject.`nashville housing data for data cleaning`;
 
 alter table portfolioproject.`nashville housing data for data cleaning`
 drop column PropertyAddress;

alter table portfolioproject.`nashville housing data for data cleaning`
drop column OwnerAddress;
 
alter table portfolioproject.`nashville housing data for data cleaning`
drop column TaxDistrict; 

alter table portfolioproject.`nashville housing data for data cleaning`
drop column SaleYear;
 
 